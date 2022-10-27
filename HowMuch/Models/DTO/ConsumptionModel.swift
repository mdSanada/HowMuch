//
//  ConsumptionModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - ConsumptionModel
struct ConsumptionModel: Codable {
    var name, consumptionDescription, level: String?
    var time: Int?
    var nivel: String?
    var measurement: String?
    var consumption: String?

    enum CodingKeys: String, CodingKey {
        case name
        case consumptionDescription = "description"
        case nivel
        case measurement
        case level, time, consumption
    }
    
    internal init(name: String? = nil, consumptionDescription: String? = nil, measurement: String? = nil, nivel: String? = nil, level: String? = nil, time: Int? = nil, consumption: String? = nil) {
        self.name = name
        self.consumptionDescription = consumptionDescription
        self.level = level
        self.measurement = measurement
        self.nivel = nivel
        self.time = time
        self.consumption = consumption
    }
}
