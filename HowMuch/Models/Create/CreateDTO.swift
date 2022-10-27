//
//  CreateDTO.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 26/10/22.
//

import Foundation
import UIKit

struct CreateDTO {
    let section: String
    let showTitle: Bool
    let itens: [CreateType]
}

extension CreateDTO {
    static func sales() -> [CreateDTO] {
        var result:[CreateDTO] = []
        var array:[CreateType]  = []
        // MARK: - Image Section
        array.append(CreateType.image)
        
        result.append(CreateDTO(section: "Imagem",
                                showTitle: false,
                                itens: array))
        array.removeAll()
        
        // MARK: - Description Section
        array.append(.text(TextFieldViewModelCell(item: CreateTextModel(key: "",
                                                                        title: "Nome",
                                                                        placeholder: "Nome",
                                                                        textFieldType: .text,
                                                                        type: .title))))
        array.append(.text(TextFieldViewModelCell(item: CreateTextModel(key: "",
                                                                        title: "Descrição",
                                                                        placeholder: "Descrição",
                                                                        textFieldType: .text,
                                                                        type: .body))))
        array.append(.text(TextFieldViewModelCell(item: CreateTextModel(key: "",
                                                                        title: "Lucro",
                                                                        placeholder: "Lucro",
                                                                        textFieldType: .currency,
                                                                        type: .body))))
        array.append(.text(TextFieldViewModelCell(item: CreateTextModel(key: "",
                                                                        title: "Rendimento",
                                                                        placeholder: "Rendimento",
                                                                        textFieldType: .currency,
                                                                        type: .body))))
        
        result.append(CreateDTO(section: "Descrição",
                                showTitle: false,
                                itens: array))
        array.removeAll()
        
        // MARK: - Ingredients Section
        array.append(CreateType.item(CreateItemModel(title: "Adicionar novo",
                                                     itemType: .add)))
        
        result.append(CreateDTO(section: "Ingredientes",
                                showTitle: true,
                                itens: array))
        array.removeAll()
        
        // MARK: - Materials Section
        array.append(CreateType.item(CreateItemModel(title: "Adicionar novo",
                                                     itemType: .add)))
        
        result.append(CreateDTO(section: "Materiais",
                                showTitle: true,
                                itens: array))
        array.removeAll()
        
        // MARK: - Taxes Section
        array.append(CreateType.item(CreateItemModel(title: "Adicionar novo",
                                                     itemType: .add)))
        
        result.append(CreateDTO(section: "Impostos",
                                showTitle: true,
                                itens: array))
        array.removeAll()
        
        // MARK: - Consumption Section
        array.append(CreateType.item(CreateItemModel(title: "Adicionar novo",
                                                     itemType: .add)))
        
        result.append(CreateDTO(section: "Consumo",
                                showTitle: true,
                                itens: array))
        array.removeAll()
        
        return result
    }
    
    static func materials(type: MaterialsType) -> [CreateDTO] {
        switch type {
        case .ingredient:
            return IngredientsModel.create()
        case .material:
            // MARK: - Material Section
            return MaterialModel.create()
        case .taxes:
            // MARK: - Taxes Section
            return TaxeModel.create()
        case .consumption:
            // MARK: - Consumption Section
            return ConsumptionModel.create()
        }
    }
}
