//
//  TaxeModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - TaxeModel
struct TaxeModel: Codable {
    var name, taxeDescription, measurement: String?
    var quantity: Double?
    var cost: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case taxeDescription = "description"
        case measurement, quantity, cost
    }
    
    internal init(name: String? = nil, taxeDescription: String? = nil, measurement: String? = nil, quantity: Double? = nil, cost: Double? = nil) {
        self.name = name
        self.taxeDescription = taxeDescription
        self.measurement = measurement
        self.quantity = quantity
        self.cost = cost
    }
}

extension TaxeModel: Creatable {
    static func editable(model: TaxeModel) -> [CreateDTO] {
        var result:[CreateDTO] = []
        var array:[CreateType]  = []
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: TaxeModel.CodingKeys.name.rawValue,
                                                                                  title: "Nome",
                                                                                  placeholder: "Nome",
                                                                                  initial: model.name,
                                                                                  textFieldType: .text,
                                                                                  type: .title))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: TaxeModel.CodingKeys.taxeDescription.rawValue,
                                                                                  title: "Descrição",
                                                                                  placeholder: "Descrição",
                                                                                  initial: model.taxeDescription,
                                                                                  textFieldType: .text,
                                                                                  type: .body))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: TaxeModel.CodingKeys.cost.rawValue,
                                                                                  title: "Custo (%)",
                                                                                  placeholder: "0 %",
                                                                                  initial: model.cost?.asString(),
                                                                                  textFieldType: .percent,
                                                                                  type: .body))))
        result.append(CreateDTO(section: "Descrição", showTitle: false, itens: array))

        return result
    }
    
    static func create() -> [CreateDTO] {
        var result:[CreateDTO] = []
        var array:[CreateType]  = []
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: TaxeModel.CodingKeys.name.rawValue,
                                                                                  title: "Nome",
                                                                                  placeholder: "Nome",
                                                                                  initial: nil,
                                                                                  textFieldType: .text,
                                                                                  type: .title))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: TaxeModel.CodingKeys.taxeDescription.rawValue,
                                                                                  title: "Descrição",
                                                                                  placeholder: "Descrição",
                                                                                  initial: nil,
                                                                                  textFieldType: .text,
                                                                                  type: .body))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: TaxeModel.CodingKeys.cost.rawValue,
                                                                                  title: "Custo (%)",
                                                                                  placeholder: "0 %",
                                                                                  initial: nil,
                                                                                  textFieldType: .percent,
                                                                                  type: .body))))
        result.append(CreateDTO(section: "Descrição", showTitle: false, itens: array))

        return result
    }
}
