//
//  BugdetModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - BudgetModel
struct BudgetModel: Codable {
    let name, budgetDescription: String?
    let itens: [Item]?

    enum CodingKeys: String, CodingKey {
        case name
        case budgetDescription = "description"
        case itens
    }
}

// MARK: - Item
struct Item: Codable {
    let id: FirestoreId?
    let quantity: Int?
}
