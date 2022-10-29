//
//  MeasureType.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 25/10/22.
//

import Foundation

enum MeasureType: String, CaseIterable {
    case grams = "GRAMS"
    case kilograms = "KILOGRAMS"
    case unit = "UNIT"
    case milliliter = "MILLILITER"
    case liter = "LITER"
    case percent = "PERCENT"
}

extension MeasureType: MenuProtocol {
    func dict() -> [String : String] {
        MeasureType.dict()
    }
    
    func defaultValue() -> String {
        return dict()[self.rawValue.uppercased()] ?? ""
    }
    
    static func dict() -> [String: String] {
        var dict: [String: String] = [:]
         MeasureType.allCases.forEach { measure in
            switch measure {
            case .grams:
                return dict[measure.rawValue] = "g"
            case .kilograms:
                return dict[measure.rawValue] = "Kg"
            case .unit:
                return dict[measure.rawValue] = "un."
            case .milliliter:
                return dict[measure.rawValue] = "mL"
            case .liter:
                return dict[measure.rawValue] = "L"
            case .percent:
                return dict[measure.rawValue] = "%"
            }
        }
        return dict
    }
}
