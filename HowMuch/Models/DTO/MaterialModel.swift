//
//  MaterialModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - MaterialModel
struct MaterialModel: Codable {
    var name, materialDescription, measurement: String?
    var quantity: Int?
    var cost: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case materialDescription = "description"
        case measurement, quantity, cost
    }
    
    internal init(name: String? = nil, materialDescription: String? = nil, measurement: String? = nil, quantity: Int? = nil, cost: Double? = nil) {
        self.name = name
        self.materialDescription = materialDescription
        self.measurement = measurement
        self.quantity = quantity
        self.cost = cost
    }
}
