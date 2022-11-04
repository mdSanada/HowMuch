//
//  AddItemIOProtocol.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 03/11/22.
//

import Foundation

protocol AddItemInputProtocol: AnyObject {
    func awake()
}

protocol AddItemOutputProtocol: AnyObject {
    func configure(title: String, quantity: String, value: String)
}
