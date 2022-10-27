//
//  TextFieldTypes.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 27/10/22.
//

import Foundation
import UIKit

enum TextFieldTypes {
    case text
    case currency
    case percent
    case number
}

extension TextFieldTypes {
    func keyboard() -> UIKeyboardType {
        switch self {
        case .text:
            return .default
        case .currency:
            return .decimalPad
        case .percent:
            return .numberPad
        case .number:
            return .decimalPad
        }
    }
}
