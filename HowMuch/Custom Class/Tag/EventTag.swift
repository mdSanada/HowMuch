//
//  EventTag.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 28/09/22.
//

import UIKit

enum EventTag: Int {
    case daily = 0
    case treatment = 1
    case vaterinary = 2
}

extension EventTag {
    func color(alpha: CGFloat = 1) -> UIColor {
        switch self {
        case .daily:
            return .cyan.withAlphaComponent(alpha)
        case .treatment:
            return .red.withAlphaComponent(alpha)
        case .vaterinary:
            return .green.withAlphaComponent(alpha)
        }
    }
    
    func title() -> String {
        switch self {
        case .daily:
            return "Diário"
        case .treatment:
            return "Tratamento"
        case .vaterinary:
            return "Veterinário"
        }
    }
}
