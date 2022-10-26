//
//  CreateModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 25/10/22.
//

import Foundation
import UIKit

enum ItemType {
    case item
    case add
}

enum CreateType {
    case image
    case text
    case selectable
    case item
}

class CreateModel {
    let title: String?
    let placeholder: String?
    let keyboard: UIKeyboardType?
    let selectable: [String]?
    let type: TextFieldTableViewCellType?
    let itemType: ItemType?
 
    internal init(title: String? = nil,
                  placeholder: String? = nil,
                  keyboard: UIKeyboardType? = nil,
                  selectable: [String]? = nil,
                  type: TextFieldTableViewCellType? = nil,
                  itemType: ItemType? = nil) {
        self.title = title
        self.placeholder = placeholder
        self.keyboard = keyboard
        self.type = type
        self.itemType = itemType
        self.selectable = selectable
    }
}

struct CreateDTO {
    let section: String
    let showTitle: Bool
    let type: CreateType
    let itens: [CreateModel]
}

extension CreateDTO {
    static func sales() -> [CreateDTO] {
        var result:[CreateDTO] = []
        var array:[CreateModel]  = []
        // MARK: - Image Section
        array.append(CreateModel())
        
        result.append(CreateDTO(section: "Imagem",
                                     showTitle: false,
                                     type: .image,
                                     itens: array))
        array.removeAll()
        
        // MARK: - Description Section
        array.append(CreateModel(title: "Nome", placeholder: "Nome", keyboard: .default, type: .title))
        
        array.append(CreateModel(title: "Descrição", placeholder: "Descrição", keyboard: .default, type: .body))
        array.append(CreateModel(title: "Lucro", placeholder: "Lucro", keyboard: .numberPad, type: .body))
        array.append(CreateModel(title: "Rendimento", placeholder: "Rendimento", keyboard: .numberPad, type: .body))
        
        result.append(CreateDTO(section: "Descrição", showTitle: false, type: .text, itens: array))
        array.removeAll()
        
        // MARK: - Ingredients Section
        array.append(CreateModel(title: "Adicionar novo", itemType: .add))
        
        result.append(CreateDTO(section: "Ingredientes",
                                     showTitle: true,
                                     type: .item,
                                     itens: array))
        array.removeAll()

        // MARK: - Materials Section
        array.append(CreateModel(title: "Adicionar novo", itemType: .add))

        result.append(CreateDTO(section: "Materiais",
                                     showTitle: true,
                                     type: .item,
                                     itens: array))
        array.removeAll()

        // MARK: - Taxes Section
        array.append(CreateModel(title: "Adicionar novo", itemType: .add))

        result.append(CreateDTO(section: "Impostos",
                                     showTitle: true,
                                     type: .item,
                                     itens: array))
        array.removeAll()

        // MARK: - Consumption Section
        array.append(CreateModel(title: "Adicionar novo",
                                      itemType: .add))

        result.append(CreateDTO(section: "Consumo",
                                     showTitle: true,
                                     type: .item,
                                     itens: array))
        array.removeAll()

        return result
    }
    
    static func chooseMaterials() -> [CreateDTO] {
        var result:[CreateDTO] = []
        var array:[CreateModel]  = []

        // MARK: - Tipo Section
        array.append(CreateModel(title: "Tipo", selectable: MaterialsType.allCases.map { $0.rawValue } ))
        
        result.append(CreateDTO(section: "Tipo", showTitle: true, type: .selectable, itens: array))
        array.removeAll()
        
        // MARK: - Unidade de Medida Section
        array.append(CreateModel(title: "Unidade de Medida", selectable: MeasureType.allCases.map { $0.rawValue } ))
        
        result.append(CreateDTO(section: "Unidade de Medida", showTitle: true, type: .selectable, itens: array))
        array.removeAll()
        
        return result
    }

    
    static func materials(type: MaterialsType) -> [CreateDTO] {
        var result:[CreateDTO] = []
        var array:[CreateModel]  = []
        switch type {
        case .ingredient:
            // MARK: - Description Section
            array.append(CreateModel(title: "Nome", placeholder: "Nome", keyboard: .default, type: .title))
            array.append(CreateModel(title: "Descrição", placeholder: "Descrição", keyboard: .default, type: .body))
            array.append(CreateModel(title: "Custo (R$)", placeholder: "R$ 0,00", keyboard: .numberPad, type: .body))
            array.append(CreateModel(title: "Quantidade", placeholder: "Quantidade", keyboard: .numberPad, type: .menu(MeasureType.allCases.map { $0.rawValue },
                                                                                                                       initial: MeasureType.gramas.rawValue,
                                                                                                                       hiddenInput: false)))
            
            result.append(CreateDTO(section: "Descrição", showTitle: false, type: .text, itens: array))
            array.removeAll()
            
            return result
        case .material:
            // MARK: - Description Section
            array.append(CreateModel(title: "Nome", placeholder: "Nome", keyboard: .default, type: .title))
            array.append(CreateModel(title: "Descrição", placeholder: "Descrição", keyboard: .default, type: .body))
            array.append(CreateModel(title: "Custo (R$)", placeholder: "R$ 0,00", keyboard: .numberPad, type: .body))
            array.append(CreateModel(title: "Quantidade", placeholder: "Quantidade", keyboard: .numberPad, type: .menu(MeasureType.allCases.map { $0.rawValue },
                                                                                                                       initial: MeasureType.unidade.rawValue,
                                                                                                                       hiddenInput: false)))
            
            result.append(CreateDTO(section: "Descrição", showTitle: false, type: .text, itens: array))
            array.removeAll()
            
            return result
        case .taxes:
            // MARK: - Description Section
            array.append(CreateModel(title: "Nome", placeholder: "Nome", keyboard: .default, type: .title))
            array.append(CreateModel(title: "Descrição", placeholder: "Descrição", keyboard: .default, type: .body))
            array.append(CreateModel(title: "Custo (%)", placeholder: "0 %", keyboard: .numberPad, type: .body))
            
            result.append(CreateDTO(section: "Descrição", showTitle: false, type: .text, itens: array))
            array.removeAll()
            
            return result
        case .consumption:
            // MARK: - Description Section
            array.append(CreateModel(title: "Nome", placeholder: "Nome", keyboard: .default, type: .title))
            array.append(CreateModel(title: "Descrição", placeholder: "Descrição", keyboard: .default, type: .body))
            array.append(CreateModel(title: "Consumo", placeholder: "", keyboard: .numberPad, type: .menu(ConsumptionType.allCases.map { $0.rawValue },
                                                                                                               initial: ConsumptionType.gas.rawValue,
                                                                                                               hiddenInput: true)))
            array.append(CreateModel(title: "Nível", placeholder: "", keyboard: .numberPad, type: .menu(NivelType.allCases.map { $0.rawValue },
                                                                                                               initial: NivelType.low.rawValue,
                                                                                                               hiddenInput: true)))
            array.append(CreateModel(title: "Tempo", placeholder: "Tempo", keyboard: .numberPad, type: .menu(TimeType.allCases.map { $0.rawValue },
                                                                                                                  initial: TimeType.min.rawValue,
                                                                                                                  hiddenInput: false)))
            
            result.append(CreateDTO(section: "Descrição", showTitle: false, type: .text, itens: array))
            array.removeAll()
            
            return result
        }
    }
}
