//
//  TaxeModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - TaxeModel
struct TaxeModel: Codable {
    var name, taxeDescription, measurement: String?
    var quantity: Int?
    var cost: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case taxeDescription = "description"
        case measurement, quantity, cost
    }
    
    internal init(name: String? = nil, taxeDescription: String? = nil, measurement: String? = nil, quantity: Int? = nil, cost: Double? = nil) {
        self.name = name
        self.taxeDescription = taxeDescription
        self.measurement = measurement
        self.quantity = quantity
        self.cost = cost
    }
}
