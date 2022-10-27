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
                                                                        keyboard: .default,
                                                                        type: .title))))
        array.append(.text(TextFieldViewModelCell(item: CreateTextModel(key: "",
                                                                        title: "Descrição",
                                                                        placeholder: "Descrição",
                                                                        keyboard: .default,
                                                                        type: .body))))
        array.append(.text(TextFieldViewModelCell(item: CreateTextModel(key: "",
                                                                        title: "Lucro",
                                                                        placeholder: "Lucro",
                                                                        keyboard: .numberPad,
                                                                        type: .body))))
        array.append(.text(TextFieldViewModelCell(item: CreateTextModel(key: "",
                                                                        title: "Rendimento",
                                                                        placeholder: "Rendimento",
                                                                        keyboard: .numberPad,
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
        var result:[CreateDTO] = []
        var array:[CreateType]  = []
        
        switch type {
        case .ingredient:
            // MARK: - Ingredient Section
            array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: IngredientKey.name.rawValue,
                                                                                      title: "Nome",
                                                                                      placeholder: "Nome",
                                                                                      keyboard: .default,
                                                                                      type: .title))))
            array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: IngredientKey.description.rawValue,
                                                                                      title: "Descrição",
                                                                                      placeholder: "Descrição",
                                                                                      keyboard: .default,
                                                                                      type: .body))))
            array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: IngredientKey.cost.rawValue,
                                                                                      title: "Custo (R$)",
                                                                                      placeholder: "R$ 0,00",
                                                                                      keyboard: .decimalPad,
                                                                                      type: .body))))
            array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: IngredientKey.quantity.rawValue,
                                                                                      title: "Quantidade",
                                                                                      placeholder: "Quantidade",
                                                                                      keyboard: .numberPad,
                                                                                      type: .menu(MeasureType.allCases.map { $0.rawValue },
                                                                                                  initial: MeasureType.gramas.rawValue,
                                                                                                  hiddenInput: false)))))
            
            result.append(CreateDTO(section: "Descrição",
                                    showTitle: false,
                                    itens: array))
            array.removeAll()
            
            return result
        case .material:
            // MARK: - Material Section
            array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialKey.name.rawValue,
                                                                                      title: "Nome",
                                                                                      placeholder: "Nome",
                                                                                      keyboard: .default,
                                                                                      type: .title))))
            array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialKey.description.rawValue,
                                                                                      title: "Descrição",
                                                                                      placeholder: "Descrição",
                                                                                      keyboard: .default,
                                                                                      type: .body))))
            array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialKey.cost.rawValue,
                                                                                      title: "Custo (R$)",
                                                                                      placeholder: "R$ 0,00",
                                                                                      keyboard: .decimalPad,
                                                                                      type: .body))))
            array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialKey.quantity.rawValue,
                                                                                      title: "Quantidade",
                                                                                      placeholder: "Quantidade",
                                                                                      keyboard: .numberPad,
                                                                                      type: .menu(MeasureType.allCases.map { $0.rawValue },
                                                                                                  initial: MeasureType.gramas.rawValue,
                                                                                                  hiddenInput: false)))))
            
            
            result.append(CreateDTO(section: "Descrição", showTitle: false, itens: array))
            array.removeAll()
            
            return result
        case .taxes:
            // MARK: - Taxes Section
            array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: TaxesKey.name.rawValue,
                                                                                      title: "Nome",
                                                                                      placeholder: "Nome",
                                                                                      keyboard: .default,
                                                                                      type: .title))))
            array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: TaxesKey.description.rawValue,
                                                                                      title: "Descrição",
                                                                                      placeholder: "Descrição",
                                                                                      keyboard: .default,
                                                                                      type: .body))))
            array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: TaxesKey.cost.rawValue,
                                                                                      title: "Custo (%)",
                                                                                      placeholder: "0 %",
                                                                                      keyboard: .numberPad,
                                                                                      type: .body))))
            
            result.append(CreateDTO(section: "Descrição", showTitle: false, itens: array))
            array.removeAll()
            
            return result
        case .consumption:
            // MARK: - Consumption Section
            array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: ConsumptionKey.name.rawValue,
                                                                                      title: "Nome",
                                                                                      placeholder: "Nome",
                                                                                      keyboard: .default,
                                                                                      type: .title))))
            array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: ConsumptionKey.description.rawValue,
                                                                                      title: "Descrição",
                                                                                      placeholder: "Descrição",
                                                                                      keyboard: .default,
                                                                                      type: .body))))
            
            array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: ConsumptionKey.consumption.rawValue,
                                                                                      title: "Consumo",
                                                                                      placeholder: "",
                                                                                      keyboard: .numberPad,
                                                                                      type: .menu(ConsumptionType.allCases.map { $0.rawValue },
                                                                                                  initial: ConsumptionType.gas.rawValue,
                                                                                                  hiddenInput: true)))))
            array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: ConsumptionKey.nivel.rawValue,
                                                                                      title: "Nível",
                                                                                      placeholder: "",
                                                                                      keyboard: .numberPad,
                                                                                      type: .menu(NivelType.allCases.map { $0.rawValue },
                                                                                                  initial: NivelType.low.rawValue,
                                                                                                  hiddenInput: true)))))
            array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: ConsumptionKey.time.rawValue,
                                                                                      title: "Tempo",
                                                                                      placeholder: "Tempo",
                                                                                      keyboard: .numberPad,
                                                                                      type: .menu(TimeType.allCases.map { $0.rawValue },
                                                                                                  initial: TimeType.min.rawValue,
                                                                                                  hiddenInput: false)))))
            
            
            result.append(CreateDTO(section: "Descrição", showTitle: false, itens: array))
            array.removeAll()
            
            return result
        }
    }
}
