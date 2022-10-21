//
//  IngredientsModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - IngredientsModel
struct IngredientsModel: Codable {
    let name, ingredientsDescription, measurement: String?
    let quantity: Int?
    let cost: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case ingredientsDescription = "description"
        case measurement, quantity, cost
    }
}
