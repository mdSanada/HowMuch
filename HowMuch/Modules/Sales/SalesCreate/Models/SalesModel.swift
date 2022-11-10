//
//  SalesModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - SalesModel
struct SaleModel: Codable, FirestoreProtocol {
    var firestoreId: FirestoreId?
    let name, salesDescription: String?
    let profit: Double?
    let yield: Double?
    let consumption, ingredients, materials, taxes: [SaleItem]?

    enum CodingKeys: String, CodingKey {
        case firestoreId
        case name
        case salesDescription = "description"
        case profit, yield, consumption, ingredients, materials, taxes
    }
}

struct SaleItem: Codable, Hashable {
    let id: FirestoreId?
    let quantity: QuantityModelDTO?
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: SaleItem, rhs: SaleItem) -> Bool {
        lhs.id == rhs.id
    }
}

typealias SalesModel = [SaleModel]

extension SaleModel {
    static func from(material: MaterialsType) -> String {
        switch material {
        case .ingredient:
            return SaleModel.CodingKeys.ingredients.stringValue
        case .material:
            return SaleModel.CodingKeys.materials.stringValue
        case .taxes:
            return SaleModel.CodingKeys.taxes.stringValue
        case .consumption:
            return SaleModel.CodingKeys.consumption.stringValue
        }
    }
}
