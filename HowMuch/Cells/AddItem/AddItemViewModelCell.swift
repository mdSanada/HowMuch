//
//  AddItemViewModelCell.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 26/10/22.
//

import Foundation
import RxSwift
import RxCocoa

class AddItemViewModelCell: CellViewModel {
    weak var output: AddItemOutputProtocol?
    
    var completion: ((_ item: KeyValue?, _ menu: KeyValue?) -> Void)?
    var isValid = BehaviorSubject<Bool>(value: false)
    
    fileprivate let result = PublishSubject<Any?>()
    
    private let item: CreateItemModel
    private var disposeBag = DisposeBag()
    let type: ItemType?
    let title: String?
    
    var extractedValue: Any? = nil
    
    deinit {
        Sanada.print("Deinitializing: \(self)")
        disposeBag = DisposeBag()
        result.onCompleted()
    }
    
    init(item: CreateItemModel) {
        self.item = item
        self.type = item.itemType
        self.title = item.title
    }
    
    func bind(completion: @escaping ((KeyValue?, KeyValue?) -> Void)) {
        self.completion = completion
    }
}

extension AddItemViewModelCell: AddItemInputProtocol {
    func awake() {
        guard let type = type else { return }
        switch type {
        case .item(let material, let quantityDict):
            let quantity = quantityDict.data?.map(to: QuantityModelDTO.self) ?? QuantityModelDTO(quantity: 0, type: "UNIT")
            
            let unitType = MeasureType.init(rawValue: quantity.type ?? "")
            let stringQuantity = (quantity.quantity ?? 0)?.asString(digits: 2, minimum: 0) ?? ""
            let _quantity = stringQuantity + " " + (unitType?.defaultValue().value ?? "")
            
            let value = Decimal(Calculate.price(from: quantity, material: material))
            
            switch material {
            case .ingredient(let ingredient):
                let title = ingredient?.name ?? ""
                output?.configure(title: title,
                                  quantity: _quantity,
                                  value: value.asMoney())
            case .material(let _material):
                let title = _material?.name ?? ""
                
                output?.configure(title: title,
                                  quantity: _quantity,
                                  value: value.asMoney())
            case .taxes(let taxes):
                let title = taxes?.name ?? ""
                let value = (taxes?.cost ?? 0).asString().percentFormatting()
                
                output?.configure(title: title,
                                  quantity: "",
                                  value: value.percentFormatting())
            case .consumption(let consumption):
                let title = consumption?.name ?? ""
                let _consumption = consumption?.consumption ?? ""
                let nivel = consumption?.level ?? ""
                
                output?.configure(title: title,
                                  quantity: nivel,
                                  value: _consumption)
            }
        default:
            break
        }
    }
}

extension AddItemViewModelCell {
    func complete() {
        let item: KeyValue? = {
            guard let itemKey = self.item.itemType, let section = self.item.title else {
                return nil
            }
            switch itemKey {
            case .item(let materialsType, let quantity):
                switch materialsType {
                case .ingredient(let ingredientsModel):
                    return KeyValue(key: section, value: [["id": ingredientsModel?.firestoreId, "quantity": quantity]])
                case .material(let materialModel):
                    return KeyValue(key: section, value: [["id": materialModel?.firestoreId, "quantity": quantity]])
                case .taxes(let taxeModel):
                    return KeyValue(key: section, value: [["id": taxeModel?.firestoreId, "quantity": quantity]])
                case .consumption(let consumptionModel):
                    return KeyValue(key: section, value: [["id": consumptionModel?.firestoreId, "quantity": quantity]])
                }
            case .add:
                return nil
            }
        }()
        
        switch self.item.itemType {
        case .item:
            completion?(item, nil)
        default:
            break
        }
    }
    
    func clean() {
        completion = nil
        isValid.onCompleted()
        result.onCompleted()
        output?.clean()
    }
    
}
