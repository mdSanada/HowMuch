//
//  ReceiptsModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 19/10/22.
//

import UIKit

struct ReceiptModel {
    let title: String
    let description: String
    let value: Decimal
    let image: UIImage?
}

typealias ReceiptsModel = [ReceiptModel]

extension ReceiptsModel {
    static func mock() -> ReceiptsModel {
        var array: ReceiptsModel = []
        array.append(.init(title: "Brigadeiro",
                           description: "Chocolate Belga",
                           value: 3,
                           image: UIImage(named: "brigadeiro")))
        array.append(.init(title: "Brigadeiro Chocolate",
                           description: "Chocolate Belga",
                           value: 6.5,
                           image: UIImage(named: "brigadeiro")))
        array.append(.init(title: "Super Brigadeiro Bem Grande",
                           description: "Chocolate Belga",
                           value: 1,
                           image: UIImage(named: "brigadeiro")))
        return array
    }
}
