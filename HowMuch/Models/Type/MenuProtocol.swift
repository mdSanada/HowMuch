//
//  MenuProtocol.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 29/10/22.
//

import Foundation

protocol MenuProtocol {
    func dict() -> [String: String]
    func defaultValue() -> String
}
