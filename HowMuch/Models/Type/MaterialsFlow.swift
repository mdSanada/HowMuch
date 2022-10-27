//
//  MaterialsFlow.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 27/10/22.
//

import Foundation

enum MaterialsFlow {
    case save
    case update(uuid: FirestoreId)
}
