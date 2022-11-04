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
    func valueDidChange(_ value: Any?)
    func menuDidChange(_ value: String)
    func setMenuKey(_ key: String)
    func viewWillAppear()
}

protocol TextFieldOutputProtocol: AnyObject {
    func configure(type: TextFieldTableViewCellType,
                   title: String,
                   placeholder: String,
                   initial: String?,
                   textFieldType: TextFieldTypes)
    func setField(_ text: String?)
}
