//
//  SalesViewModel.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 10/09/22.
//

import Foundation
import RxCocoa
import RxSwift

enum SalesStates: SNStateful {
    case didLoad([SaleDTO])
    case filter([SaleDTO])
}

class SalesViewModel: SNViewModel<SalesStates> {
    let didLoad = PublishSubject<Void>()
    let filteredText = BehaviorSubject<String>(value: "")
    let reloadData = PublishSubject<Void>()
    private var disposeBag = DisposeBag()
    
    fileprivate var sales: [SaleDTO] {
        get {
            let sales = FirestoreInteractor.shared.sales
            let dto = SaleDTO.create(from: sales)
            return dto
        }
    }
    
    override func configure() {
        configureListeners()
        
        didLoad
            .subscribe(onNext: { [weak self] _ in
                self?.emit(.didLoad(self?.sales ?? []))
            })
            .disposed(by: disposeBag)
        
        reloadData
            .withLatestFrom(filteredText)
            .subscribe(onNext: { [weak self] text in
                self?.filter(text: text)
            })
            .disposed(by: disposeBag)
        
        filteredText
            .subscribe(onNext: { [weak self] text in
                self?.filter(text: text)
            })
            .disposed(by: disposeBag)
    }
}

extension SalesViewModel {
    fileprivate func configureListeners() {
        SNNotificationCenter.shared.addObserver(self,
                                                selector: #selector(configure(_:)),
                                                name: SNNotificationCenter.sales.name,
                                                object: nil)
    }
    
    @objc fileprivate func configure(_ notification: NSNotification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.reloadData.onNext(())
        }
    }
    
    private func filter(text: String) {
        var filtered: [SaleDTO] = []
        if text.isEmpty {
            filtered = sales
        } else {
            filtered = sales.filter({ $0.name?.lowercased().contains(text.lowercased()) ?? false })
        }

        emit(.filter(filtered))
    }
}
