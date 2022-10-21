//
//  ConsumptionModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - ConsumptionModel
struct ConsumptionModel: Codable {
    let name, consumptionDescription, level: String?
    let time: Int?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case name
        case consumptionDescription = "description"
        case level, time, type
    }
}
