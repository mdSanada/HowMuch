//
//  MaterialsType.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 25/10/22.
//

import Foundation

enum MaterialsType: CaseIterable, Equatable {
    static var allCases: [MaterialsType] = [.ingredient(nil), .material(nil), .taxes(nil), .consumption(nil)]
    
    case ingredient(IngredientsModel?)
    case material(MaterialModel?)
    case taxes(TaxeModel?)
    case consumption(ConsumptionModel?)
}

extension MaterialsType {
    static func fromTitle(_ title: String) -> MaterialsType? {
        switch title.uppercased() {
        case "Ingrediente".uppercased(): return .ingredient(nil)
        case "Material".uppercased(): return .material(nil)
        case "Taxa".uppercased(): return .taxes(nil)
        case "Consumo".uppercased(): return .consumption(nil)
        default:
            return nil
        }
    }
    
    static func fromSection(_ section: String) -> MaterialsType? {
        switch section.uppercased() {
        case "Ingredientes".uppercased(): return .ingredient(nil)
        case "Materiais".uppercased(): return .material(nil)
        case "Impostos".uppercased(): return .taxes(nil)
        case "Consumo".uppercased(): return .consumption(nil)
        default:
            return nil
        }
    }
    
    
    func title() -> String  {
        switch self {
        case .ingredient:
            return "Ingrediente"
        case .material:
            return "Material"
        case .taxes:
            return "Taxa"
        case .consumption:
            return "Consumo"
        }
    }
    
    func editTitle() -> String  {
        switch self {
        case .ingredient:
            return "Editar Ingrediente"
        case .material:
            return "Editar Material"
        case .taxes:
            return "Editar Taxa"
        case .consumption:
            return "Editar Consumo"
        }
    }
    
    func newTitle() -> String  {
        switch self {
        case .ingredient:
            return "Novo Ingrediente"
        case .material:
            return "Novo Material"
        case .taxes:
            return "Nova Taxa"
        case .consumption:
            return "Novo Consumo"
        }
    }
    
    static func ==(lhs: MaterialsType, rhs: MaterialsType) -> Bool {
        switch (lhs, rhs) {
        case (.ingredient, .ingredient):
            return true
        case (.material, .material):
            return true
        case (.taxes, .taxes):
            return true
        case (.consumption, .consumption):
            return true
        default:
            return false
        }
    }
}
