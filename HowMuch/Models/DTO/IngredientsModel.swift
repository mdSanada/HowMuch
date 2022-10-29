//
//  IngredientsModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - IngredientsModel
struct IngredientsModel: Codable, FirestoreProtocol {
    var firestoreId: FirestoreId?
    var name, ingredientsDescription, measurement: String?
    var quantity: Int?
    var cost: Double?
    
    enum CodingKeys: String, CodingKey {
        case firestoreId
        case name
        case ingredientsDescription = "description"
        case measurement, quantity, cost
    }
    
    internal init(name: String? = nil, ingredientsDescription: String? = nil, measurement: String? = nil, quantity: Int? = nil, cost: Double? = nil) {
        self.firestoreId = nil
        self.name = name
        self.ingredientsDescription = ingredientsDescription
        self.measurement = measurement
        self.quantity = quantity
        self.cost = cost
    }
}

extension IngredientsModel: Creatable {
    static func mock() -> [IngredientsModel] {
        return [IngredientsModel(name: "Ingredient 1",
                                 ingredientsDescription: "Material 1",
                                 measurement: "g",
                                 quantity: 1,
                                 cost: 1),
                IngredientsModel(name: "Ingredient 2",
                                 ingredientsDescription: "Material 2",
                                 measurement: "g",
                                 quantity: 2,
                                 cost: 2),
                IngredientsModel(name: "Ingredient 3",
                                 ingredientsDescription: "Material 3",
                                 measurement: "g",
                                 quantity: 3,
                                 cost: 3)]
    }
    
    func detailed() -> [DetailedDTO] {
        var result: [DetailedDTO] = []
        result.append(DetailedDTO(title: "Nome",
                                  description: self.name))
        result.append(DetailedDTO(title: "Descrição",
                                  description: self.ingredientsDescription))
        result.append(DetailedDTO(title: "Custo (R$)",
                                  description: self.cost?.asString().currencyInputFormatting()))
        result.append(DetailedDTO(title: "Quantidade",
                                  description: Double(self.quantity ?? 0).asString(digits: 0) + " " + (self.measurement ?? "")))
        return result
    }
    
    func editable() -> [CreateDTO] {
        var result:[CreateDTO] = []
        var array:[CreateType]  = []
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: IngredientsModel.CodingKeys.name.stringValue,
                                                                                  title: "Nome",
                                                                                  placeholder: "Nome",
                                                                                  initial: self.name,
                                                                                  textFieldType: .text,
                                                                                  type: .title))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: IngredientsModel.CodingKeys.ingredientsDescription.stringValue,
                                                                                  title: "Descrição",
                                                                                  placeholder: "Descrição",
                                                                                  initial: self.ingredientsDescription,
                                                                                  textFieldType: .text,
                                                                                  type: .body))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: IngredientsModel.CodingKeys.cost.stringValue,
                                                                                  title: "Custo (R$)",
                                                                                  placeholder: "R$ 0,00",
                                                                                  initial: self.cost?.asString(),
                                                                                  textFieldType: .currency,
                                                                                  type: .body))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: IngredientsModel.CodingKeys.quantity.stringValue,
                                                                                  title: "Quantidade",
                                                                                  placeholder: "Quantidade",
                                                                                  initial: Double(self.quantity ?? 0).asString(digits: 0),
                                                                                  textFieldType: .number,
                                                                                  type: .menu(key: IngredientsModel.CodingKeys.measurement.stringValue,
                                                                                              actionsWithInitial: MeasureType(rawValue: self.measurement ?? "") ?? .grams,
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
                                                                                              actionsWithInitial: MeasureType.grams,
                                                                                              hiddenInput: false)))))
        
        result.append(CreateDTO(section: "Descrição",
                                showTitle: false,
                                itens: array))
        return result
    }
}
