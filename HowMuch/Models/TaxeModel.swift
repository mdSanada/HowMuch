//
//  TaxeModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - TaxeModel
struct TaxeModel: Codable {
    let name, taxeDescription, measurement: String?
    let quantity: Int?
    let cost: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case taxeDescription = "description"
        case measurement, quantity, cost
    }
}
