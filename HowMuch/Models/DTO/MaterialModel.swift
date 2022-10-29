//
//  MaterialModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - MaterialModel
struct MaterialModel: Codable, FirestoreProtocol {
    var firestoreId: FirestoreId?
    var name, materialDescription, measurement: String?
    var quantity: Int?
    var cost: Double?
    
    enum CodingKeys: String, CodingKey {
        case firestoreId
        case name
        case materialDescription = "description"
        case measurement, quantity, cost
    }
        
    internal init(name: String? = nil, materialDescription: String? = nil, measurement: String? = nil, quantity: Int? = nil, cost: Double? = nil) {
        self.firestoreId = nil
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
    
    func detailed() -> [DetailedDTO] {
        var result: [DetailedDTO] = []
        result.append(DetailedDTO(title: "Nome",
                                  description: self.name))
        result.append(DetailedDTO(title: "Descrição",
                                  description: self.materialDescription))
        result.append(DetailedDTO(title: "Custo (R$)",
                                  description: self.cost?.asString().currencyInputFormatting()))
        result.append(DetailedDTO(title: "Quantidade",
                                  description: Double(self.quantity ?? 0).asString(digits: 0) + " " + (self.measurement ?? "")))
        return result
    }
    
    func editable() -> [CreateDTO] {
        var result:[CreateDTO] = []
        var array:[CreateType]  = []
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialModel.CodingKeys.name.rawValue,
                                                                                  title: "Nome",
                                                                                  placeholder: "Nome",
                                                                                  initial: self.name,
                                                                                  textFieldType: .text,
                                                                                  type: .title))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialModel.CodingKeys.materialDescription.rawValue,
                                                                                  title: "Descrição",
                                                                                  placeholder: "Descrição",
                                                                                  initial: self.materialDescription,
                                                                                  textFieldType: .text,
                                                                                  type: .body))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialModel.CodingKeys.cost.rawValue,
                                                                                  title: "Custo (R$)",
                                                                                  placeholder: "R$ 0,00",
                                                                                  initial: self.cost?.asString(),
                                                                                  textFieldType: .currency,
                                                                                  type: .body))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: MaterialModel.CodingKeys.quantity.rawValue,
                                                                                  title: "Quantidade",
                                                                                  placeholder: "Quantidade",
                                                                                  initial: Double(self.quantity ?? 0).asString(digits: 0),
                                                                                  textFieldType: .number,
                                                                                  type: .menu(key: MaterialModel.CodingKeys.measurement.stringValue,
                                                                                              actionsWithInitial: MeasureType(rawValue: self.measurement ?? "") ?? .grams,
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
                                                                                              actionsWithInitial: MeasureType.grams,
                                                                                              hiddenInput: false)))))
        
        
        result.append(CreateDTO(section: "Descrição", showTitle: false, itens: array))
        return result
    }
}
