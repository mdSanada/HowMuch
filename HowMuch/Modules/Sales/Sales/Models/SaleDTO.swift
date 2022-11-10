//
//  SaleDTO.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 08/11/22.
//

import Foundation

struct SaleDTO: FirestoreProtocol {
    var firestoreId: FirestoreId?
    let name, salesDescription: String?
    let profit: Double?
    let yield: Double?
    fileprivate(set) var unitPrice: Double? = nil
    fileprivate(set) var fullPrice: Double? = nil
    let consumption: [SaleItemConsumptionDTO]?
    let ingredients: [SaleItemIngredientDTO]?
    let materials: [SaleItemMaterialDTO]?
    let taxes: [SaleItemTaxeDTO]?
    
    enum CodingKeys: String, CodingKey {
        case firestoreId
        case name
        case salesDescription = "description"
        case profit, yield, consumption, ingredients, materials, taxes
        case unitPrice, fullPrice
    }
}

struct SaleItemConsumptionDTO {
    let consumption: ConsumptionModel?
    let quantity: QuantityModelDTO?
}

struct SaleItemIngredientDTO {
    let ingredient: IngredientsModel?
    let quantity: QuantityModelDTO?
}

struct SaleItemMaterialDTO {
    let material: MaterialModel?
    let quantity: QuantityModelDTO?
}

struct SaleItemTaxeDTO {
    let taxe: TaxeModel?
    let quantity: QuantityModelDTO?
}


extension SaleDTO {
    static func create(from sales: [SaleModel]) -> [SaleDTO] {
        guard sales.count >= 1 else { return [] }
        var result: [SaleDTO] = []
        
        result = sales.map { sale -> SaleDTO in
            let ingredients = sale.ingredients?.compactMap { _ingredients -> SaleItemIngredientDTO? in
                guard let firestoreId = _ingredients.id else { return nil }
                let item = FirestoreInteractor.shared.ingredientsDict[firestoreId]
                let dto = SaleItemIngredientDTO(ingredient: item, quantity: _ingredients.quantity)
                return dto
            }
            
            let materials = sale.materials?.compactMap { _material -> SaleItemMaterialDTO? in
                guard let firestoreId = _material.id else { return nil }
                let item = FirestoreInteractor.shared.materialsDict[firestoreId]
                let dto = SaleItemMaterialDTO(material: item, quantity: _material.quantity)
                return dto
            }
            
            let taxes = sale.taxes?.compactMap { _taxes -> SaleItemTaxeDTO? in
                guard let firestoreId = _taxes.id else { return nil }
                let item = FirestoreInteractor.shared.taxesDict[firestoreId]
                let dto = SaleItemTaxeDTO(taxe: item, quantity: _taxes.quantity)
                return dto
            }
            
            let consumption = sale.consumption?.compactMap { _consumption -> SaleItemConsumptionDTO? in
                guard let firestoreId = _consumption.id else { return nil }
                let item = FirestoreInteractor.shared.consumptionDict[firestoreId]
                let dto = SaleItemConsumptionDTO(consumption: item, quantity: _consumption.quantity)
                return dto
            }
            
            var saleDto = SaleDTO(firestoreId: sale.firestoreId,
                                  name: sale.name,
                                  salesDescription: sale.salesDescription,
                                  profit: sale.profit,
                                  yield: sale.yield,
                                  consumption: consumption,
                                  ingredients: ingredients,
                                  materials: materials,
                                  taxes: taxes)
            
            return saleDto.addPrice()
        }
        
        return result
    }
    
    private mutating func addPrice() -> SaleDTO {
        let ingredientsPrice = self.ingredients?.reduce(0.0, { partialResult, item in
            guard let quantity = item.quantity else { return partialResult }
            return partialResult + (item.ingredient?.calculate(quantity: quantity) ?? 0)
        }) ?? 0
        
        let materialsPrice = self.materials?.reduce(0.0, { partialResult, item in
            guard let quantity = item.quantity else { return partialResult }
            return partialResult + (item.material?.calculate(quantity: quantity) ?? 0)
        }) ?? 0
        
        let taxesPrice = self.taxes?.reduce(0.0, { partialResult, item in
            guard let quantity = item.quantity else { return partialResult }
            return partialResult + (item.taxe?.calculate(quantity: quantity) ?? 0)
        }) ?? 0
        
        let consumptionPrice = self.consumption?.reduce(0.0, { partialResult, item in
            guard let quantity = item.quantity else { return partialResult }
            return partialResult + (item.consumption?.calculate(quantity: quantity) ?? 0)
        }) ?? 0
        
        let price = ingredientsPrice + materialsPrice + taxesPrice + consumptionPrice
        
        let total = price * ((self.profit ?? 100) / 100)
        let unit = total / (self.yield ?? 1)
        
        self.unitPrice = unit
        self.fullPrice = total
        
        return self
    }
}
