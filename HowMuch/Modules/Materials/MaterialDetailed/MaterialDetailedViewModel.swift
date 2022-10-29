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
    case deleted
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
        configureListener()
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

extension MaterialDetailedViewModel {
    func delete(material: MaterialsType, id: FirestoreId) {
        switch material {
        case .ingredient:
            FirestoreRepository.shared.deleteIngredient(id: id) { [weak self] success in
                if success {
                    self?.emit(.deleted)
                } else {
                    self?.emit(.error("Erro"))
                }
            }
        case .material:
            FirestoreRepository.shared.deleteMaterial(id: id) { [weak self] success in
                if success {
                    self?.emit(.deleted)
                } else {
                    self?.emit(.error("Erro"))
                }
            }
        case .taxes:
            FirestoreRepository.shared.deleteTaxes(id: id) { [weak self] success in
                if success {
                    self?.emit(.deleted)
                } else {
                    self?.emit(.error("Erro"))
                }
            }
        case .consumption:
            FirestoreRepository.shared.deleteConsumption(id: id) { [weak self] success in
                if success {
                    self?.emit(.deleted)
                } else {
                    self?.emit(.error("Erro"))
                }
            }
        }
    }
    
    func configureListener() {
        do {
            let id = try firestoreId.value()
            let notification = SNNotificationModel(notification: "MaterialDetailed.\(id)")
            print("MaterialDetailed.\(id)")
            SNNotificationCenter.shared.addObserver(self,
                                                    selector: #selector(configure(_:)),
                                                    name: notification.name,
                                                    object: nil)
        } catch {
            Sanada.print("Erro")
        }
    }
    
    func reloadData() {
        do {
            let id = try firestoreId.value()
            let material = try type.value()
            switch material {
            case .ingredient:
                FirestoreRepository.shared.getIngredient(source: .default, id: id) { [weak self] ingredient in
                    guard let ingredient = ingredient else {
                        return
                    }
                    self?.emit(.configure(id: id, type: .ingredient(ingredient)))
                }
            case .material:
                FirestoreRepository.shared.getMaterial(source: .default, id: id) { [weak self] material in
                    guard let material = material else {
                        return
                    }
                    self?.emit(.configure(id: id, type: .material(material)))
                }
            case .taxes:
                FirestoreRepository.shared.getTaxes(source: .default, id: id) { [weak self] taxes in
                    guard let taxes = taxes else {
                        return
                    }
                    self?.emit(.configure(id: id, type: .taxes(taxes)))
                }
            case .consumption:
                FirestoreRepository.shared.getConsumption(source: .default, id: id) { [weak self] consumption in
                    guard let consumption = consumption else {
                        return
                    }
                    self?.emit(.configure(id: id, type: .consumption(consumption)))
                }
            }
        } catch {
            Sanada.print("Erro")
        }
    }
    
    @objc private func configure(_ notification: NSNotification) {
        reloadData()
    }
}
