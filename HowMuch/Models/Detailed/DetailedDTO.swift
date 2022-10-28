//
//  DetailedDTO.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 28/10/22.
//

import Foundation

struct DetailedDTO {
    let title: String
    let description: String?
}

extension DetailedDTO {
    static func detailed(type: MaterialsType) -> [DetailedDTO] {
        switch type {
        case .ingredient(let ingredient):
            guard let ingredient = ingredient else {
                return []
            }
            return ingredient.detailed()
        case .material(let material):
            // MARK: - Material Section
            guard let material = material else {
                return []
            }
            return material.detailed()
        case .taxes(let taxes):
            // MARK: - Taxes Section
            guard let taxes = taxes else {
                return []
            }
            return taxes.detailed()
        case .consumption(let consumption):
            // MARK: - Consumption Section
            guard let consumption = consumption else {
                return []
            }
            return consumption.detailed()
        }
    }

}
