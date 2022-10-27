//
//  MaterialModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - MaterialModel
struct MaterialModel: Codable {
    var name, materialDescription, measurement: String?
    var quantity: Int?
    var cost: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case materialDescription = "description"
        case measurement, quantity, cost
    }
    
    internal init(name: String? = nil, materialDescription: String? = nil, measurement: String? = nil, quantity: Int? = nil, cost: Double? = nil) {
        self.name = name
        self.materialDescription = materialDescription
        self.measurement = measurement
        self.quantity = quantity
        self.cost = cost
    }
}

extension MaterialModel: Creatable {
    static func create() -> [CreateDTO] {
        var result:[CreateDTO] = []
        var array:[CreateType]  = []
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialModel.CodingKeys.name.rawValue,
                                                                                  title: "Nome",
                                                                                  placeholder: "Nome",
                                                                                  textFieldType: .text,
                                                                                  type: .title))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialModel.CodingKeys.materialDescription.rawValue,
                                                                                  title: "Descrição",
                                                                                  placeholder: "Descrição",
                                                                                  textFieldType: .text,
                                                                                  type: .body))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialModel.CodingKeys.cost.rawValue,
                                                                                  title: "Custo (R$)",
                                                                                  placeholder: "R$ 0,00",
                                                                                  textFieldType: .currency,
                                                                                  type: .body))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialModel.CodingKeys.quantity.rawValue,
                                                                                  title: "Quantidade",
                                                                                  placeholder: "Quantidade",
                                                                                  textFieldType: .number,
                                                                                  type: .menu(key: MaterialModel.CodingKeys.measurement.stringValue,
                                                                                              actions: MeasureType.allCases.map { $0.rawValue },
                                                                                              initial: MeasureType.gramas.rawValue,
                                                                                              hiddenInput: false)))))


        result.append(CreateDTO(section: "Descrição", showTitle: false, itens: array))
        return result
    }
}
