//
//  MeasureType.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 25/10/22.
//

import Foundation

enum MeasureType: String, CaseIterable, Codable {
    case grams = "GRAMS"
    case kilograms = "KILOGRAMS"
    case unit = "UNIT"
    case milliliter = "MILLILITER"
    case liter = "LITER"
    case percent = "PERCENT"
    
    init(from decoder: Decoder) throws {
        let label = try decoder.singleValueContainer().decode(String.self)
        switch label {
        case "GRAMS": self = .grams
        case "KILOGRAMS": self = .kilograms
        case "UNIT": self = .unit
        case "MILLILITER": self = .milliliter
        case "LITER": self = .liter
        case "PERCENT": self = .percent
        default: self = .unit
        }
    }
}

extension MeasureType: MenuProtocol {
    func dict() -> [String : String] {
        MeasureType.dict()
    }
    
    func defaultValue() -> (key: String, value: String) {
        return (key: self.rawValue.uppercased(), value: dict()[self.rawValue.uppercased()] ?? "")
    }
    
    static func dict(from: [MeasureType]) -> [String: String] {
        var dict: [String: String] = [:]
        from.forEach { measure in
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
