//
//  EventTag.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 28/09/22.
//

import UIKit

enum StatusDirection {
    case right
    case left
}

enum Status: Int {
    case current = 0
    case finished = 1
    case completed = 2
}

extension Status {
    func color(alpha: CGFloat = 1) -> UIColor {
        switch self {
        case .current:
            return .accent.withAlphaComponent(alpha)
        case .finished:
            return .red.withAlphaComponent(alpha)
        case .completed:
            return .green.withAlphaComponent(alpha)
        }
    }
    
    func title() -> String {
        switch self {
        case .current:
            return "Em andamento"
        case .finished:
            return "Finalizado"
        case .completed:
            return "Completo"
        }
    }
}
