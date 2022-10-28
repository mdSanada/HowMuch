//
//  SalesModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - SalesModel
struct SaleModel: Codable, FirestoreProtocol {
    var firestoreId: FirestoreId?
    let name, salesDescription: String?
    let profit: Double?
    let yield: Double?
    let consumption, ingredients, materials, taxes: [FirestoreId]?

    enum CodingKeys: String, CodingKey {
        case firestoreId
        case name
        case salesDescription = "description"
        case profit, yield, consumption, ingredients, materials, taxes
    }
}

typealias SalesModel = [SaleModel]
