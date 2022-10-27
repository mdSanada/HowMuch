//
//  MaterialsType.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 25/10/22.
//

import Foundation

enum MaterialsType: String, CaseIterable {
    case ingredient = "Ingredientes"
    case material = "Materiais"
    case taxes = "Impostos"
    case consumption = "Consumo"
}

extension MaterialsType {
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
