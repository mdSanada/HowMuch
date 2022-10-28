//
//  MaterialDetailedViewModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 28/10/22.
//

import Foundation
import RxCocoa
import RxSwift

enum MaterialDetailedStates: SNStateful {
    case success(String)
    case loading(Bool)
    case error(String)
    case configure(id: FirestoreId, type: MaterialsType)
}

class MaterialDetailedViewModel: SNViewModel<MaterialDetailedStates> {
    let didLoad = PublishSubject<Void>()
    
    private let firestoreId: BehaviorSubject<FirestoreId>
    private let type: BehaviorSubject<MaterialsType>
    private var disposeBag = DisposeBag()

    init(id: FirestoreId, type: MaterialsType) {
        self.firestoreId = BehaviorSubject<FirestoreId>(value: id)
        self.type = BehaviorSubject<MaterialsType>(value: type)
        super.init()
    }
    
    override func configure() {
        didLoad
            .withLatestFrom(firestoreId)
            .withLatestFrom(type, resultSelector: {(uuid: $0, type: $1)})
            .subscribe(onNext: { [weak self] (uuid, type) in
                self?.emit(.configure(id: uuid, type: type))
            })
            .disposed(by: disposeBag)
    }
}
