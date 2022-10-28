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
    static func mock() -> [MaterialModel] {
        return [MaterialModel(name: "Material 1",
                              materialDescription: "Material 1",
                              measurement: "g",
                              quantity: 1,
                              cost: 1),
                MaterialModel(name: "Material 2",
                              materialDescription: "Material 2",
                              measurement: "g",
                              quantity: 2,
                              cost: 2),
                MaterialModel(name: "Material 3",
                              materialDescription: "Material 3",
                              measurement: "g",
                              quantity: 3,
                              cost: 3)]
    }
    
    static func editable(model: MaterialModel) -> [CreateDTO] {
        var result:[CreateDTO] = []
        var array:[CreateType]  = []
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialModel.CodingKeys.name.rawValue,
                                                                                  title: "Nome",
                                                                                  placeholder: "Nome",
                                                                                  initial: model.name,
                                                                                  textFieldType: .text,
                                                                                  type: .title))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialModel.CodingKeys.materialDescription.rawValue,
                                                                                  title: "Descrição",
                                                                                  placeholder: "Descrição",
                                                                                  initial: model.materialDescription,
                                                                                  textFieldType: .text,
                                                                                  type: .body))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialModel.CodingKeys.cost.rawValue,
                                                                                  title: "Custo (R$)",
                                                                                  placeholder: "R$ 0,00",
                                                                                  initial: model.cost?.asString(),
                                                                                  textFieldType: .currency,
                                                                                  type: .body))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialModel.CodingKeys.quantity.rawValue,
                                                                                  title: "Quantidade",
                                                                                  placeholder: "Quantidade",
                                                                                  initial: Double(model.quantity ?? 0).asString(digits: 0),
                                                                                  textFieldType: .number,
                                                                                  type: .menu(key: MaterialModel.CodingKeys.measurement.stringValue,
                                                                                              actions: MeasureType.allCases.map { $0.rawValue },
                                                                                              initial: MeasureType.gramas.rawValue,
                                                                                              hiddenInput: false)))))
        
        
        result.append(CreateDTO(section: "Descrição", showTitle: false, itens: array))
        return result
    }

    
    static func create() -> [CreateDTO] {
        var result:[CreateDTO] = []
        var array:[CreateType]  = []
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialModel.CodingKeys.name.rawValue,
                                                                                  title: "Nome",
                                                                                  placeholder: "Nome",
                                                                                  initial: nil,
                                                                                  textFieldType: .text,
                                                                                  type: .title))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialModel.CodingKeys.materialDescription.rawValue,
                                                                                  title: "Descrição",
                                                                                  placeholder: "Descrição",
                                                                                  initial: nil,
                                                                                  textFieldType: .text,
                                                                                  type: .body))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialModel.CodingKeys.cost.rawValue,
                                                                                  title: "Custo (R$)",
                                                                                  placeholder: "R$ 0,00",
                                                                                  initial: nil,
                                                                                  textFieldType: .currency,
                                                                                  type: .body))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialModel.CodingKeys.quantity.rawValue,
                                                                                  title: "Quantidade",
                                                                                  placeholder: "Quantidade",
                                                                                  initial: nil,
                                                                                  textFieldType: .number,
                                                                                  type: .menu(key: MaterialModel.CodingKeys.measurement.stringValue,
                                                                                              actions: MeasureType.allCases.map { $0.rawValue },
                                                                                              initial: MeasureType.gramas.rawValue,
                                                                                              hiddenInput: false)))))
        
        
        result.append(CreateDTO(section: "Descrição", showTitle: false, itens: array))
        return result
    }
}
