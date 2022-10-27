//
//  CreateType.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 26/10/22.
//

import Foundation

enum CreateType {
    case image
    case text(TextFieldViewModelCell)
    case item(CreateItemModel?)
}
