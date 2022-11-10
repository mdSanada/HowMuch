//
//  QuantityModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 09/11/22.
//

import Foundation

struct QuantityModelDTO: Codable {
    var quantity: Double? = nil
    var type: String? = nil
}

typealias QuantityModel = [String: Any]
