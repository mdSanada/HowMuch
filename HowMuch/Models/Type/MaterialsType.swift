//
//  MaterialsType.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 25/10/22.
//

import Foundation

enum MaterialsType: CaseIterable {
    static var allCases: [MaterialsType] = [.ingredient(nil), .material(nil), .taxes(nil), .consumption(nil)]
    
    case ingredient(IngredientsModel?)
    case material(MaterialModel?)
    case taxes(TaxeModel?)
    case consumption(ConsumptionModel?)
}

extension MaterialsType {
    static func fromTitle(_ title: String) -> MaterialsType? {
        switch title {
        case "Ingrediente": return .ingredient(nil)
        case "Material": return .material(nil)
        case "Taxa": return .taxes(nil)
        case "Consumo": return .consumption(nil)
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
}
