//
//  Creatable.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 27/10/22.
//

import Foundation

protocol Creatable {
    static func create() -> [CreateDTO]
}
