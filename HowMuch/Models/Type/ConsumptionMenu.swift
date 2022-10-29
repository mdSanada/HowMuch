//
//  ConsumptionType.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 25/10/22.
//

import Foundation

enum ConsumptionType: String, CaseIterable {
    case gas = "GAS"
    case energy = "ELETRICITY"
    case water = "WATER"
}

extension ConsumptionType: MenuProtocol {
    func dict() -> [String : String] {
        ConsumptionType.dict()
    }
    
    func defaultValue() -> String {
        return dict()[self.rawValue] ?? ""
    }

    static func dict() -> [String: String] {
        var dict: [String: String] = [:]
        ConsumptionType.allCases.forEach { consumption in
            switch consumption {
            case .gas:
                return dict[consumption.rawValue] = "Gás"
            case .energy:
                return dict[consumption.rawValue] = "Eletricidade"
            case .water:
                return dict[consumption.rawValue] = "Água"
            }
        }
        return dict
    }
}
