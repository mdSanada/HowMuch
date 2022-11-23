//
//  Calculate.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 10/11/22.
//

import Foundation

struct Calculate {
    
    static func price(from dto: QuantityModelDTO, material: MaterialsType) -> Double {
        var final: Double = 0
        
        let quantity: Double = dto.quantity ?? 0
        let type: MeasureType = .init(rawValue: dto.type ?? "") ?? .unit
        let ratio: Double = MeasuresHelper.shared.ratio(from: type)
        
        switch material {
        case .ingredient(let ingredient):
            let parentValue: Double = ingredient?.cost ?? 0
            let parentQuantity: Double = ingredient?.quantity ?? 0
            let parentType: MeasureType = .init(rawValue: ingredient?.measurement ?? "") ?? .unit
            let parentRatio: Double = MeasuresHelper.shared.ratio(from: parentType)
            
            if type == .unit {
                final = parentValue * quantity
                break
            }
            
            let proportion: Double = ratio / parentRatio
            let multiplier: Double = (quantity * proportion) / parentQuantity
            
            final = parentValue * multiplier
        case .material(let material):
            let parentValue: Double = material?.cost ?? 0
            let parentQuantity: Double = material?.quantity ?? 0
            let parentType: MeasureType = .init(rawValue: material?.measurement ?? "") ?? .unit
            let parentRatio: Double = MeasuresHelper.shared.ratio(from: parentType)
            
            if type == .unit {
                final = parentValue * quantity
                break
            }
            
            let proportion: Double = ratio / parentRatio
            let multiplier: Double = (quantity * proportion) / parentQuantity
            
            final = parentValue * multiplier
        case .taxes(let taxe):
            let parentValue: Double = taxe?.cost ?? 0
            let parentQuantity: Double = taxe?.quantity ?? 0
            let parentType: MeasureType = .init(rawValue: taxe?.measurement ?? "") ?? .percent
            let parentRatio: Double = MeasuresHelper.shared.ratio(from: parentType)
            
            let proportion: Double = (ratio * quantity)

            final = parentValue * proportion
        case .consumption(let consumption):
            break
        }
        
        return final
    }
}
