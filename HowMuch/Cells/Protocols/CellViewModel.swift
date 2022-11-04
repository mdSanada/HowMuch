//
//  CellViewModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 27/10/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol CellViewModel {
    var completion: ((_ item: KeyValue?, _ menu: KeyValue?) -> Void)? { get set }
    var isValid: BehaviorSubject<Bool> { get }
    func bind(completion: @escaping ((KeyValue?, KeyValue?) -> Void))
    func complete()
    func clean()
}
