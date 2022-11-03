//
//  SelectMaterialsViewModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 02/11/22.
//

import Foundation
import RxCocoa
import RxSwift

enum SelectMaterialsStates: SNStateful {
    case didLoad(MaterialsType)
    case filter([Any])
}

class SelectMaterialsViewModel: SNViewModel<SelectMaterialsStates> {
    let didLoad = PublishSubject<Void>()
    let filteredText = BehaviorSubject<String>(value: "")
    let choosedSubject = PublishSubject<MaterialsType>()
    let reloadData = PublishSubject<Void>()
    private var disposeBag = DisposeBag()
    
    fileprivate var materials: [MaterialModel] {
        get {
            return FirestoreInteractor.shared.materials
        }
    }
    fileprivate var ingredients: [IngredientsModel] {
        get {
            return FirestoreInteractor.shared.ingredients
        }
    }
    fileprivate var taxes: [TaxeModel] {
        get {
            return FirestoreInteractor.shared.taxes
        }
    }
    fileprivate var consumptions: [ConsumptionModel] {
        get {
            return FirestoreInteractor.shared.consumption
        }
    }
    
    init(type: MaterialsType) {
        super.init()
        choosedSubject.onNext(type)
    }
    
    override func configure() {
        configureListeners()
        
        didLoad
            .withLatestFrom(choosedSubject)
            .subscribe(onNext: { [weak self] type in
                self?.emit(.didLoad(type))
            })
            .disposed(by: disposeBag)
        
        reloadData
            .withLatestFrom(filteredText)
            .withLatestFrom(choosedSubject, resultSelector: {(text: $0, segment: $1)})
            .subscribe(onNext: { [weak self] text, type in
                self?.filter(text: text, type: type)
            })
            .disposed(by: disposeBag)
        
        filteredText
            .withLatestFrom(choosedSubject, resultSelector: {(text: $0, segment: $1)})
            .subscribe(onNext: { [weak self] text, type in
                self?.filter(text: text, type: type)
            })
            .disposed(by: disposeBag)
    }
}

extension SelectMaterialsViewModel {
    fileprivate func configureListeners() {
        SNNotificationCenter.shared.addObserver(self,
                                                selector: #selector(configure(_:)),
                                                name: SNNotificationCenter.materials.name,
                                                object: nil)
    }
    
    @objc fileprivate func configure(_ notification: NSNotification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.reloadData.onNext(())
        }
    }
    
    private func filter(text: String, type: MaterialsType) {
        var filtered:[Any] = []
        switch type {
        case .ingredient:
            if text.isEmpty {
                filtered = ingredients
            } else {
                filtered = ingredients.filter({ $0.name?.lowercased().contains(text.lowercased()) ?? false })
            }
        case .material:
            if text.isEmpty {
                filtered = materials
            } else {
                filtered = materials.filter({ $0.name?.lowercased().contains(text.lowercased()) ?? false })
            }
        case .taxes:
            if text.isEmpty {
                filtered = taxes
            } else {
                filtered = taxes.filter({ $0.name?.lowercased().contains(text.lowercased()) ?? false })
            }
        case .consumption:
            if text.isEmpty {
                filtered = consumptions
            } else {
                filtered = consumptions.filter({ $0.name?.lowercased().contains(text.lowercased()) ?? false })
            }
        }
        emit(.filter(filtered))
    }
}
