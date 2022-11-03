//
//  QuantityMaterialViewModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 02/11/22.
//

import Foundation
import RxCocoa
import RxSwift

enum QuantityMaterialStates: SNStateful {
    case didLoad(MaterialsType)
}

class QuantityMaterialViewModel: SNViewModel<QuantityMaterialStates> {
    let didLoad = PublishSubject<Void>()

    private let typeSubject = PublishSubject<MaterialsType>()
    private var disposeBag = DisposeBag()
    
    init(type: MaterialsType) {
        super.init()
        typeSubject.onNext(type)
    }
    
    override func configure() {
        didLoad
            .withLatestFrom(typeSubject)
            .subscribe(onNext: { [weak self] type in
                self?.emit(.didLoad(type))
            })
            .disposed(by: disposeBag)
    }
}
