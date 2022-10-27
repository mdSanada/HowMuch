//
//  MaterialCreateViewModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 26/10/22.
//

import Foundation
import RxSwift
import RxCocoa

enum MaterialCreateStates: SNStateful {
    case success(String)
    case loading(Bool)
    case error(String)
    case configure([CreateDTO])
    case button(enabled: Bool)
}

class MaterialCreateViewModel: SNViewModel<MaterialCreateStates> {
    // MARK: - Inputs
    let type = BehaviorSubject<MaterialsType?>(value: nil)
    let flow = BehaviorSubject<MaterialsFlow?>(value: nil)

    // MARK: - Repository
    let repository = FirestoreRepository.shared
    
    // MARK: - Itens
    var itens: [CreateDTO] = [] {
        didSet {
            populateViewModels(itens: itens)
            emit(.configure(itens))
        }
    }
    var cellViewModels: [CellViewModel] = []
    var disposeBag = DisposeBag()
    
    var result: [String: Any] = [:]

    // MARK: - CONFIGURE
    override func configure() {
        type
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] type in
                self?.itens = CreateDTO.materials(type: type)
            })
            .disposed(by: disposeBag)
        
        let isValidObservable = Observable.combineLatest(cellViewModels.map { $0.isValid })
        
        isValidObservable
            .map { $0.allSatisfy { $0 } }
            .subscribe(onNext: { [weak self] _valid in
                self?.emit(.button(enabled: _valid))
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - INPUT ACTION
extension MaterialCreateViewModel {
    func complete() {
        for viewModel in cellViewModels {
            viewModel.complete()
        }
        do {
            guard let _flow = try flow.value() else { return }
            switch _flow {
            case .save:
                save()
            case .update(let uuid):
                update(uuid: uuid)
            }
        } catch {
            emit(.error("Erro"))
        }
    }
        
    func completion(_ item: KeyValue?, _ menu: KeyValue?) {
        if let item = item {
            result[item.key] = item.value
        }

        if let menu = menu {
            result[menu.key] = menu.value
        }
    }
}

// MARK: - LIFE CYCLE
extension MaterialCreateViewModel {
    func clean() {
        cellViewModels.forEach { $0.clean() }
    }

    fileprivate func populateViewModels(itens: [CreateDTO]) {
        itens.forEach { section in
            section.itens.forEach { row in
                switch row {
                case .text(let viewModel):
                    cellViewModels.append(viewModel)
                default:
                    break
                }
            }
        }
    }
}

// MARK: - REPOSITORY
extension MaterialCreateViewModel {
    func save() {
        do {
            guard let _type = try type.value() else { return }
            guard let json = result.data else { return }
            repository.save(material: _type, data: json) { [weak self] success in
                self?.emit(.success("Salvo com sucesso"))
            }
        } catch {
            emit(.error("Erro"))
        }
        Sanada.print(result)
    }
    
    func update(uuid: FirestoreId) {
        do {
            guard let _type = try type.value() else { return }
            guard let json = result.data else { return }
            repository.update(uuid: uuid, material: _type, data: json) { [weak self] success in
                self?.emit(.success("Salvo com sucesso"))
            }
        } catch {
            emit(.error("Erro"))
        }
        Sanada.print(result)
    }
}
