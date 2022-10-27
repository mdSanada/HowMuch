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
    private let item: CreateTextModel
    weak var output: TextFieldOutputProtocol?
    private var disposeBag = DisposeBag()
    
    fileprivate let result = PublishSubject<Any?>()
    fileprivate let menu = PublishSubject<String>()
    
    var completion: ((_ item: KeyValue?, _ menu: KeyValue?) -> Void)?
    var isValid = BehaviorSubject<Bool>(value: false)
    
    var menuKey: String? = nil
    var extractedValue: Any? = nil
    var extractedMenu: String? = nil
    
    deinit {
        Sanada.print("Deinitializing: \(self)")
        disposeBag = DisposeBag()
        result.onCompleted()
        menu.onCompleted()
        completion = nil
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
    func setMenuKey(_ key: String) {
        menuKey = key
    }
    
    func awake() {
        output?.configure(type: item.type ?? .body,
                          title: item.title ?? "",
                          placeholder: item.placeholder ?? "",
                          textFieldType: item.textFieldType ?? .text)
    }
    
    func valueDidChange(_ value: Any?) {
        result.onNext(value)
    }
    
    func menuDidChange(_ value: String) {
        menu.onNext(value)
    }
}
