//
//  Measures.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 09/11/22.
//

import Foundation

enum MeasuresType: String, CaseIterable, Codable {
    case weight = "WEIGHT"
    case liquid = "LIQUID"
    case percent = "PERCENT"
    case unit = "UNIT"
    
    init(from decoder: Decoder) throws {
        let label = try decoder.singleValueContainer().decode(String.self)
        switch label {
        case "WEIGHT": self = .weight
        case "LIQUID": self = .liquid
        case "UNIT": self = .unit
        case "PERCENT": self = .percent
        default: self = .unit
        }
    }
}

struct MeasuresDefault: Codable {
    let type: MeasuresType
    let defaultMesure: MeasureType
}

struct Measures: Codable {
    let type: MeasuresType
    let mesure: MeasureType
    let ratio: Double?
}

struct MeasuresHelper {
    static let shared = MeasuresHelper()
    
    private(set) var types: [MeasuresDefault] = {
        let json = MeasuresJSON.types
        return transform([MeasuresDefault].self, value: json) ?? []
    }()
    
    private(set) var measures: [Measures] = {
        let json = MeasuresJSON.measures
        return transform([Measures].self, value: json) ?? []
    }()
    
    private static func transform<D: Decodable>(_ type: D.Type, value: String) -> D? {
        let decoder = JSONDecoder()
        let jsonData = Data(value.utf8)

        do {
            var model = try decoder.decode(type.self, from: jsonData)
            return model
        } catch {
            return nil
        }
    }
    
    func type(from: MeasureType) -> MeasuresType? {
        return measures.first { measure in
            if measure.mesure == .unit {
                return measure.type.rawValue == from.rawValue
            }
            return measure.mesure.rawValue == from.rawValue
        }.map { $0.type }
    }
    
    func ratio(from: MeasureType) -> Double {
        return measures.first { measure in
            return measure.mesure.rawValue == from.rawValue
        }.map { $0.ratio ?? 1 } ?? 1
    }
    
    func select(from: MeasureType) -> [Measures] {
        let type = type(from: from)
        return measures.filter { $0.type.rawValue == type?.rawValue }
    }
}
