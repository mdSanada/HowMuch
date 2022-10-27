//
//  TextFieldViewModelCell.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 26/10/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol CellViewModel {
    var completion: ((_ key: String, _ value: String?, _ menu: String?) -> Void)? { get set }
    var isValid: BehaviorSubject<Bool> { get }
    func complete()
    func clean()
}

class TextFieldViewModelCell: CellViewModel {
    private let item: CreateTextModel
    weak var output: TextFieldOutputProtocol?
    private var disposeBag = DisposeBag()
    
    fileprivate let result = PublishSubject<String>()
    fileprivate let menu = PublishSubject<String>()
    
    var completion: ((_ key: String, _ value: String?, _ menu: String?) -> Void)?
    var isValid = BehaviorSubject<Bool>(value: false)
    
    var extractedValue: String? = ""
    var extractedMenu: String? = ""
    
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
        completion?(item.key, extractedValue, extractedMenu)
    }
}

extension TextFieldViewModelCell: TextFieldInputProtocol {
    func awake() {
        output?.configure(type: item.type ?? .body,
                          title: item.title ?? "",
                          placeholder: item.placeholder ?? "",
                          keyboard: item.keyboard ?? .default)
    }
    
    func valueDidChange(_ value: String) {
        result.onNext(value)
    }
    
    func menuDidChange(_ value: String) {
        menu.onNext(value)
    }
}
