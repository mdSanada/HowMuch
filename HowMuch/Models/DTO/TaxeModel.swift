//
//  TaxeModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - TaxeModel
struct TaxeModel: Codable, FirestoreProtocol {
    var firestoreId: FirestoreId?
    var name, taxeDescription, measurement: String?
    var quantity: Double?
    var cost: Double?
    
    enum CodingKeys: String, CodingKey {
        case firestoreId
        case name
        case taxeDescription = "description"
        case measurement, quantity, cost
    }
    
    internal init(name: String? = nil, taxeDescription: String? = nil, measurement: String? = nil, quantity: Double? = nil, cost: Double? = nil) {
        self.firestoreId = nil
        self.name = name
        self.taxeDescription = taxeDescription
        self.measurement = measurement
        self.quantity = quantity
        self.cost = cost
    }
}

extension TaxeModel: Creatable {
    static func mock() -> [TaxeModel] {
        return [TaxeModel(name: "Taxe 1",
                          taxeDescription: "Taxe 1",
                          measurement: "%",
                          quantity: 1.1,
                          cost: 1.1),
                TaxeModel(name: "Taxe 2",
                          taxeDescription: "Taxe 2",
                          measurement: "%",
                          quantity: 2.2,
                          cost: 2.2),
                TaxeModel(name: "Taxe3",
                          taxeDescription: "Taxe3",
                          measurement: "%",
                          quantity: 3.3,
                          cost: 3.3)]
    }
    
    func calculate(quantity: QuantityModelDTO) -> Double {
        return Calculate.price(from: quantity, material: .taxes(self))
    }

    func detailed() -> [DetailedDTO] {
        var result: [DetailedDTO] = []
        result.append(DetailedDTO(title: "Nome",
                                  description: self.name))
        result.append(DetailedDTO(title: "Descrição",
                                  description: self.taxeDescription))
        result.append(DetailedDTO(title: "Custo (%)",
                                  description: self.cost?.asString().percentFormatting()))
        return result
    }
    
    func editable() -> [CreateDTO] {
        var result:[CreateDTO] = []
        var array:[CreateType]  = []
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: TaxeModel.CodingKeys.name.rawValue,
                                                                                  title: "Nome",
                                                                                  placeholder: "Nome",
                                                                                  initial: self.name,
                                                                                  textFieldType: .text,
                                                                                  type: .title))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: TaxeModel.CodingKeys.taxeDescription.rawValue,
                                                                                  title: "Descrição",
                                                                                  placeholder: "Descrição",
                                                                                  initial: self.taxeDescription,
                                                                                  textFieldType: .text,
                                                                                  type: .body))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: TaxeModel.CodingKeys.cost.rawValue,
                                                                                  title: "Custo (%)",
                                                                                  placeholder: "0 %",
                                                                                  initial: self.cost?.asString(),
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
