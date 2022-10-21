//
//  MaterialModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - MaterialModel
struct MaterialModel: Codable {
    let name, materialDescription, measurement: String?
    let quantity: Int?
    let cost: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case materialDescription = "description"
        case measurement, quantity, cost
    }
}
