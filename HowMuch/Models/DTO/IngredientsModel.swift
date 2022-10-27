//
//  IngredientsModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - IngredientsModel
struct IngredientsModel: Codable {
    var name, ingredientsDescription, measurement: String?
    var quantity: Int?
    var cost: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case ingredientsDescription = "description"
        case measurement, quantity, cost
    }
    
    internal init(name: String? = nil, ingredientsDescription: String? = nil, measurement: String? = nil, quantity: Int? = nil, cost: Double? = nil) {
        self.name = name
        self.ingredientsDescription = ingredientsDescription
        self.measurement = measurement
        self.quantity = quantity
        self.cost = cost
    }
}
