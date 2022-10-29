//
//  ConsumptionType.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 25/10/22.
//

import Foundation

enum NivelType: String, CaseIterable {
    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"
}

extension NivelType: MenuProtocol {
    func dict() -> [String : String] {
        NivelType.dict()
    }
    
    func defaultValue() -> String {
        return dict()[self.rawValue] ?? ""
    }

    static func dict() -> [String: String] {
        var dict: [String: String] = [:]
        NivelType.allCases.forEach { nivel in
            switch nivel {
            case .low:
                return dict[nivel.rawValue] = "Baixo"
            case .medium:
                return dict[nivel.rawValue] = "Médio"
            case .high:
                return dict[nivel.rawValue] = "Alto"
            }
        }
        return dict
    }
}
