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
    // Inputs
    let type = BehaviorSubject<MaterialsType?>(value: nil)
    
    // Repository
    let repository = FirestoreRepository.shared
    
    // Itens
    var itens: [CreateDTO] = [] {
        didSet {
            populateViewModels(itens: itens)
            emit(.configure(itens))
        }
    }
    var cellViewModels: [CellViewModel] = []
    var disposeBag = DisposeBag()
    
    fileprivate var ingredients = IngredientsModel()
    fileprivate var material = MaterialModel()
    fileprivate var tax = TaxeModel()
    fileprivate var consumption = ConsumptionModel()

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
    
    private func populateViewModels(itens: [CreateDTO]) {
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

extension MaterialCreateViewModel {
    func complete() {
        for viewModel in cellViewModels {
            viewModel.complete()
        }
        save()
    }
    
    func clean() {
        cellViewModels.forEach { $0.clean() }
    }
    
    func save() {
        do {
            guard let type = try type.value() else { return }
            switch type {
            case .ingredient:
                Sanada.print(ingredients)
            case .material:
                Sanada.print(material)
            case .taxes:
                Sanada.print(tax)
            case .consumption:
                Sanada.print(consumption)
            }
        } catch {
            emit(.error("Erro"))
        }

    }

    func completion(_ key: String, _ value: String?, _ menu: String?) {
        // TODO: - Map to object and save firestore
        do {
            guard let type = try type.value() else { return }
            switch type {
            case .ingredient:
                guard let _key = IngredientKey(rawValue: key) else { return }
                switch _key {
                case .name:
                    ingredients.name = value
                case .description:
                    ingredients.ingredientsDescription = value
                case .cost:
                    ingredients.cost = Double(value ?? "")
                case .quantity:
                    ingredients.quantity = Int(value ?? "")
                    ingredients.measurement = menu
                }
            case .material:
                guard let _key = MaterialKey(rawValue: key) else { return }
                switch _key {
                case .name:
                    material.name = value
                case .description:
                    material.materialDescription = value
                case .cost:
                    material.cost = Double(value ?? "")
                case .quantity:
                    material.quantity = Int(value ?? "")
                    material.measurement = menu
                }
            case .taxes:
                guard let _key = TaxesKey(rawValue: key) else { return }
                switch _key {
                case .name:
                    tax.name = value
                case .description:
                    tax.taxeDescription = value
                case .cost:
                    tax.cost = Double(value ?? "")
                }
            case .consumption:
                guard let _key = ConsumptionKey(rawValue: key) else { return }
                switch _key {
                case .name:
                    consumption.name = value
                case .description:
                    consumption.consumptionDescription = value
                case .consumption:
                    consumption.consumption = menu
                case .nivel:
                    consumption.nivel = menu
                case .time:
                    consumption.time = Int(value ?? "")
                    consumption.measurement = menu
                }
            }
        } catch {
            emit(.error("Erro"))
        }
    }
}
