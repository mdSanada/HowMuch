//
//  TextFieldViewModelCell.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 26/10/22.
//

import Foundation
import RxSwift
import RxCocoa

class TextFieldViewModelCell: CellViewModel {
    weak var output: TextFieldOutputProtocol?
    
    fileprivate let result = PublishSubject<Any?>()
    fileprivate let menu = PublishSubject<String>()
    
    var completion: ((_ item: KeyValue?, _ menu: KeyValue?) -> Void)?
    var isValid = BehaviorSubject<Bool>(value: false)
    
    var menuKey: String? = nil
    var extractedValue: Any? = nil
    var extractedMenu: String? = nil
    
    private let item: CreateTextModel
    private var disposeBag = DisposeBag()

    deinit {
        Sanada.print("Deinitializing: \(self)")
        disposeBag = DisposeBag()
        result.onCompleted()
        menu.onCompleted()
    }
    
    init(item: CreateTextModel) {
        self.item = item
        result
            .subscribe(onNext: { [weak self] item in
                self?.extractedValue = item
            })
            .disposed(by: disposeBag)
        
        menu
            .subscribe(onNext: { [weak self] item in
                self?.extractedMenu = item
            })
            .disposed(by: disposeBag)
    }
    
    func clean() {
        completion = nil
    }
    
    func complete() {
        let item: KeyValue? = {
            guard let itemKey = self.item.key else {
                return nil
            }
           return KeyValue(key: itemKey, value: extractedValue)
        }()

        let menu: KeyValue? = {
            guard let menuKey = menuKey else {
                return nil
            }
           return KeyValue(key: menuKey, value: extractedMenu)
        }()
        completion?(item, menu)
    }
}

extension TextFieldViewModelCell: TextFieldInputProtocol {
    func viewWillAppear() {
        switch item.textFieldType {
        case .text:
            output?.setField(extractedValue as? String)
        case .currency:
            let number = (extractedValue as? Double)?.asString(digits: 2, minimum: 2)
            output?.setField(number?.currencyInputFormatting())
        case .percent:
            let number = (extractedValue as? Double)?.asString(digits: 2, minimum: 0)
            output?.setField(number?.percentFormatting())
        case .number:
            let number = (extractedValue as? Double)?.asString(digits: 2, minimum: 0)
            output?.setField(number?.numberFormatting())
        default:
            output?.setField(nil)
        }
    }
    
    func setMenuKey(_ key: String) {
        menuKey = key
    }
    
    func awake() {
        output?.configure(type: item.type ?? .body,
                          title: item.title ?? "",
                          placeholder: item.placeholder ?? "",
                          initial: item.initial,
                          textFieldType: item.textFieldType ?? .text)
    }
    
    func valueDidChange(_ value: Any?) {
        result.onNext(value)
    }
    
    func menuDidChange(_ value: String) {
        menu.onNext(value)
    }
}
