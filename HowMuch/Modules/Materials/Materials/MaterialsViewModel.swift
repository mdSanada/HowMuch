//
//  MaterialsViewModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 01/11/22.
//

import Foundation
import RxCocoa
import RxSwift

enum MaterialsStates: SNStateful {
    case didLoad
    case filter([Any])
}

class MaterialsViewModel: SNViewModel<MaterialsStates> {
    let didLoad = PublishSubject<Void>()
    let filteredText = BehaviorSubject<String>(value: "")
    let choosedSubject = PublishSubject<String>()
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
    
    override func configure() {
        configureListeners()
        
        reloadData
            .withLatestFrom(filteredText)
            .withLatestFrom(choosedSubject, resultSelector: {(text: $0, segment: $1)})
            .subscribe(onNext: { [weak self] text, segment in
                self?.filter(text: text, segment: segment)
            })
            .disposed(by: disposeBag)
        
        filteredText
            .withLatestFrom(choosedSubject, resultSelector: {(text: $0, segment: $1)})
            .subscribe(onNext: { [weak self] text, segment in
                self?.filter(text: text, segment: segment)
            })
            .disposed(by: disposeBag)
    }
}

extension MaterialsViewModel {
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
    
    // TODO: Change to view model
    private func filter(text: String, segment: String) {
        guard let type = MaterialsType.fromTitle(segment) else { return  }
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
