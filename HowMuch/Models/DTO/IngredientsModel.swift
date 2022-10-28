//
//  IngredientsModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - IngredientsModel
struct IngredientsModel: Codable {
    var name, ingredientsDescription, measurement: String?
    var quantity: Int?
    var cost: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case ingredientsDescription = "description"
        case measurement, quantity, cost
    }
    
    internal init(name: String? = nil, ingredientsDescription: String? = nil, measurement: String? = nil, quantity: Int? = nil, cost: Double? = nil) {
        self.name = name
        self.ingredientsDescription = ingredientsDescription
        self.measurement = measurement
        self.quantity = quantity
        self.cost = cost
    }
}

extension IngredientsModel: Creatable {
    static func editable(model: IngredientsModel) -> [CreateDTO] {
        var result:[CreateDTO] = []
        var array:[CreateType]  = []
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: IngredientsModel.CodingKeys.name.stringValue,
                                                                                  title: "Nome",
                                                                                  placeholder: "Nome",
                                                                                  initial: model.name,
                                                                                  textFieldType: .text,
                                                                                  type: .title))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: IngredientsModel.CodingKeys.ingredientsDescription.stringValue,
                                                                                  title: "Descrição",
                                                                                  placeholder: "Descrição",
                                                                                  initial: model.ingredientsDescription,
                                                                                  textFieldType: .text,
                                                                                  type: .body))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: IngredientsModel.CodingKeys.cost.stringValue,
                                                                                  title: "Custo (R$)",
                                                                                  placeholder: "R$ 0,00",
                                                                                  initial: model.cost?.asString(),
                                                                                  textFieldType: .currency,
                                                                                  type: .body))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: IngredientsModel.CodingKeys.quantity.stringValue,
                                                                                  title: "Quantidade",
                                                                                  placeholder: "Quantidade",
                                                                                  initial: Double(model.quantity ?? 0).asString(digits: 0),
                                                                                  textFieldType: .number,
                                                                                  type: .menu(key: IngredientsModel.CodingKeys.measurement.stringValue,
                                                                                              actions: MeasureType.allCases.map { $0.rawValue },
                                                                                              initial: MeasureType.gramas.rawValue,
                                                                                              hiddenInput: false)))))

        result.append(CreateDTO(section: "Descrição",
                                showTitle: false,
                                itens: array))
        return result
    }

    static func create() -> [CreateDTO] {
        var result:[CreateDTO] = []
        var array:[CreateType]  = []
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: IngredientsModel.CodingKeys.name.stringValue,
                                                                                  title: "Nome",
                                                                                  placeholder: "Nome",
                                                                                  initial: nil,
                                                                                  textFieldType: .text,
                                                                                  type: .title))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: IngredientsModel.CodingKeys.ingredientsDescription.stringValue,
                                                                                  title: "Descrição",
                                                                                  placeholder: "Descrição",
                                                                                  initial: nil,
                                                                                  textFieldType: .text,
                                                                                  type: .body))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: IngredientsModel.CodingKeys.cost.stringValue,
                                                                                  title: "Custo (R$)",
                                                                                  placeholder: "R$ 0,00",
                                                                                  initial: nil,
                                                                                  textFieldType: .currency,
                                                                                  type: .body))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: IngredientsModel.CodingKeys.quantity.stringValue,
                                                                                  title: "Quantidade",
                                                                                  placeholder: "Quantidade",
                                                                                  initial: nil,
                                                                                  textFieldType: .number,
                                                                                  type: .menu(key: IngredientsModel.CodingKeys.measurement.stringValue,
                                                                                              actions: MeasureType.allCases.map { $0.rawValue },
                                                                                              initial: MeasureType.gramas.rawValue,
                                                                                              hiddenInput: false)))))

        result.append(CreateDTO(section: "Descrição",
                                showTitle: false,
                                itens: array))
        return result
    }
}
