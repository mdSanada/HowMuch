//
//  TextFieldIOProtocol.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 26/10/22.
//

import UIKit
import RxSwift
import RxCocoa

protocol TextFieldInputProtocol: AnyObject {
    func awake()
    func valueDidChange(_ value: String)
    func menuDidChange(_ value: String)
}

protocol TextFieldOutputProtocol: AnyObject {
    func configure(type: TextFieldTableViewCellType,
                   title: String,
                   placeholder: String,
                   keyboard: UIKeyboardType)
}
