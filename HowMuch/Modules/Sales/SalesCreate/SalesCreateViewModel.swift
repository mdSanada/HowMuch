//
//  SalesCreateViewModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 03/11/22.
//

import Foundation
import RxCocoa
import RxSwift

enum SalesCreateStates: SNStateful {
    case success(String)
    case loading(Bool)
    case error(String)
    case configure([CreateDTO])
    case reload(new: [CreateDTO], section: Int)
    case button(enabled: Bool)
}

class SalesCreateViewModel: SNViewModel<SalesCreateStates> {
    // MARK: - Inputs
    let flow = BehaviorSubject<MaterialsFlow?>(value: nil)
    let addItem = PublishSubject<(type: MaterialsType, quantity: Double)>()
    let removeItem = PublishSubject<(section: Int, row: Int)>()

    // MARK: - Repository
    let repository = FirestoreRepository.shared
    
    // MARK: - Itens
    var itens: [CreateDTO] = [] {
        didSet {
            for item in itens {
                item.itens.forEach { type in
                    switch type {
                    case .image:
                        Sanada.print("image")
                    case .text(let viewModel):
                        viewModel.bind(completion: self.completion)
                    case .item(let viewModel):
                        viewModel.bind(completion: self.completion)
                    }
                }
            }
        }
    }

    var result: [String: Any] = [:] {
        didSet {
            Sanada.print(result)
        }
    }

    private var disposeBag = DisposeBag()

    override func configure() {
        addItem
            .subscribe(onNext: { [weak self] item in
                self?.addItem(type: item.type, quantity: item.quantity)
            })
            .disposed(by: disposeBag)
        
        removeItem
            .subscribe(onNext: { [weak self] item in
                self?.removeItem(section: item.section, row: item.row)
            })
            .disposed(by: disposeBag)
        
        flow
            .subscribe(onNext: { [weak self] flow in
                switch flow {
                case .update:
                    Sanada.print("Not implemented")
//                    self?.itens = CreateDTO.editable(type: type)
                case .save:
                    self?.itens = CreateDTO.sales()
                default:
                    self?.emit(.error("Erro"))
                }
                                
                self?.emit(.configure(self?.itens ?? []))
            })
            .disposed(by: disposeBag)
        
        let isValidObservable = Observable.combineLatest(getCellViewModels().map { $0.isValid })
        
        isValidObservable
            .map { $0.allSatisfy { $0 } }
            .subscribe(onNext: { [weak self] _valid in
                self?.emit(.button(enabled: _valid))
            })
            .disposed(by: disposeBag)

    }
}
// MARK: - INPUT ACTION
extension SalesCreateViewModel {
    func complete() {
        result = [:]
        
        
        for item in itens {
            for type in item.itens {
                switch type {
                case .image:
                    Sanada.print("image")
                case .text(let viewModel):
                    viewModel.complete()
                case .item(let viewModel):
                    viewModel.complete()
                }
            }
        }

//        emit(.success(""))
//        do {
//            guard let _flow = try flow.value() else { return }
//            switch _flow {
//            case .save:
//                save()
//            case .update(let uuid):
//                update(uuid: uuid)
//            }
//        } catch {
//            emit(.error("Erro"))
//        }
    }
        
    func completion(_ item: KeyValue?, _ menu: KeyValue?) {
        if let item = item {
            if let dict = (result[item.key] as? Dictionary<String, Any>),
               let value = (item.value as? Dictionary<String, Any>) {
                result[item.key] = dict.merging(value) { (_, new) in new }
            } else if let value = (item.value as? [Dictionary<String, Any>]) {
                if var dict = (result[item.key] as? [Dictionary<String, Any>]) {
                    dict.append(contentsOf: value)
                    result[item.key] = dict
                } else {
                    var dict: [Dictionary<String, Any>] = []
                    dict.append(contentsOf: value)
                    result[item.key] = dict
                }
            } else {
                result[item.key] = item.value
            }
        }
        
        if let menu = menu {
            result[menu.key] = menu.value
        }
    }
}

// MARK: - LIFE CYCLE
extension SalesCreateViewModel {
    func clean() {
        getCellViewModels().forEach { $0.clean() }
    }

    func getCellViewModels() -> [CellViewModel] {
        var cellViewModels: [CellViewModel] = []
        for item in itens {
            item.itens.forEach { type in
                switch type {
                case .image:
                    Sanada.print("image")
                case .text(let viewModel):
                    cellViewModels.append(viewModel)
                case .item(let viewModel):
                    cellViewModels.append(viewModel)
                }
            }
        }
        return cellViewModels
    }
    
    func addItem(type: MaterialsType, quantity: Double) {
        for (index, create) in itens.enumerated() {
            guard let material = MaterialsType.fromSection(create.section) else { continue }
            
            if material == type {
                let item = CreateItemModel(title: SaleModel.from(material: material),
                                           itemType: .item(type, quantity: quantity))
                let viewModel = AddItemViewModelCell(item: item)
                self.itens[index].itens.insert(.item(viewModel), at: 0)
                emit(.reload(new: itens, section: index))
                break
            }
            continue
        }
    }
    
    func removeItem(section: Int, row: Int) {
        itens[section].itens.remove(at: row)
        emit(.reload(new: itens, section: section))
    }

}

// MARK: - REPOSITORY
extension SalesCreateViewModel {
}
