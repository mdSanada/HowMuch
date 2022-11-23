//
//  ConsumptionModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - ConsumptionModel
struct ConsumptionModel: Codable, FirestoreProtocol {
    var firestoreId: FirestoreId?
    var name, consumptionDescription, level: String?
    var time: Double?
    var measurement: String?
    var consumption: String?
    
    enum CodingKeys: String, CodingKey {
        case firestoreId
        case name
        case consumptionDescription = "description"
        case measurement
        case level, time, consumption
    }
    
    internal init(name: String? = nil, consumptionDescription: String? = nil, measurement: String? = nil, level: String? = nil, time: Double? = nil, consumption: String? = nil) {
        self.firestoreId = nil
        self.name = name
        self.consumptionDescription = consumptionDescription
        self.level = level
        self.measurement = measurement
        self.time = time
        self.consumption = consumption
    }
}

extension ConsumptionModel: Creatable {
    static func mock() -> [ConsumptionModel] {
        return [ConsumptionModel(name: "Consumo",
                                 consumptionDescription: "Consumo",
                                 measurement: "min",
                                 level: "Baixo",
                                 time: 30,
                                 consumption: "Gás"),
                ConsumptionModel(name: "Consumo",
                                 consumptionDescription: "Consumo",
                                 measurement: "min",
                                 level: "Médio",
                                 time: 180,
                                 consumption: "Água"),
                ConsumptionModel(name: "Consumo",
                                 consumptionDescription: "Consumo",
                                 measurement: "h",
                                 level: "Alto",
                                 time: 1,
                                 consumption: "Eletricidade")]
    }
    
    func calculate(quantity: QuantityModelDTO) -> Double {
        return Calculate.price(from: quantity, material: .consumption(self))
    }
    
    func detailed() -> [DetailedDTO] {
        var result: [DetailedDTO] = []
        result.append(DetailedDTO(title: "Nome",
                                  description: self.name))
        result.append(DetailedDTO(title: "Descrição",
                                  description: self.consumptionDescription))
        result.append(DetailedDTO(title: "Consumo",
                                  description: self.consumption))
        result.append(DetailedDTO(title: "Nível",
                                  description: self.level))
        result.append(DetailedDTO(title: "Tempo",
                                  description: (self.time?.asString(digits: 2, minimum: 0) ?? "") + " " + (self.measurement ?? "")))
        return result
    }
    
    func editable() -> [CreateDTO] {
        var result:[CreateDTO] = []
        var array:[CreateType]  = []
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: ConsumptionModel.CodingKeys.name.rawValue,
                                                                                  title: "Nome",
                                                                                  placeholder: "Nome",
                                                                                  initial: self.name,
                                                                                  textFieldType: .text,
                                                                                  type: .title))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: ConsumptionModel.CodingKeys.consumptionDescription.rawValue,
                                                                                  title: "Descrição",
                                                                                  placeholder: "Descrição",
                                                                                  initial: self.consumptionDescription,
                                                                                  textFieldType: .text,
                                                                                  type: .body))))
        
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: nil,
                                                                                  title: "Consumo",
                                                                                  placeholder: "",
                                                                                  initial: nil,
                                                                                  textFieldType: .text,
                                                                                  type: .menu(key: ConsumptionModel.CodingKeys.consumption.rawValue,
                                                                                              actionsWithInitial: ConsumptionType(rawValue: self.consumption ?? "") ?? .gas,
                                                                                              hiddenInput: true)))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: nil,
                                                                                  title: "Nível",
                                                                                  placeholder: "",
                                                                                  initial: nil,
                                                                                  textFieldType: .currency,
                                                                                  type: .menu(key: ConsumptionModel.CodingKeys.level.rawValue,
                                                                                              actionsWithInitial: NivelType(rawValue: self.level ?? "") ?? .low,
                                                                                              hiddenInput: true)))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: ConsumptionModel.CodingKeys.time.rawValue,
                                                                                  title: "Tempo",
                                                                                  placeholder: "Tempo",
                                                                                  initial: self.time?.asString(),
                                                                                  textFieldType: .number,
                                                                                  type: .menu(key: ConsumptionModel.CodingKeys.measurement.rawValue,
                                                                                              actionsWithInitial: TimeType(rawValue: self.measurement ?? "") ?? .min,
                                                                                              hiddenInput: false)))))
        result.append(CreateDTO(section: "Descrição", showTitle: false, itens: array))
        
        return result
    }
    
    static func create() -> [CreateDTO] {
        var result:[CreateDTO] = []
        var array:[CreateType]  = []
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: ConsumptionModel.CodingKeys.name.rawValue,
                                                                                  title: "Nome",
                                                                                  placeholder: "Nome",
                                                                                  initial: nil,
                                                                                  textFieldType: .text,
                                                                                  type: .title))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: ConsumptionModel.CodingKeys.consumptionDescription.rawValue,
                                                                                  title: "Descrição",
                                                                                  placeholder: "Descrição",
                                                                                  initial: nil,
                                                                                  textFieldType: .text,
                                                                                  type: .body))))
        
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: nil,
                                                                                  title: "Consumo",
                                                                                  placeholder: "",
                                                                                  initial: nil,
                                                                                  textFieldType: .text,
                                                                                  type: .menu(key: ConsumptionModel.CodingKeys.consumption.rawValue,
                                                                                              actionsWithInitial: ConsumptionType.gas,
                                                                                              hiddenInput: true)))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: nil,
                                                                                  title: "Nível",
                                                                                  placeholder: "",
                                                                                  initial: nil,
                                                                                  textFieldType: .currency,
                                                                                  type: .menu(key: ConsumptionModel.CodingKeys.level.rawValue,
                                                                                              actionsWithInitial: NivelType.low,
                                                                                              hiddenInput: true)))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: ConsumptionModel.CodingKeys.time.rawValue,
                                                                                  title: "Tempo",
                                                                                  placeholder: "Tempo",
                                                                                  initial: nil,
                                                                                  textFieldType: .number,
                                                                                  type: .menu(key: ConsumptionModel.CodingKeys.measurement.rawValue,
                                                                                              actionsWithInitial: TimeType.min,
                                                                                              hiddenInput: false)))))
        
        
        result.append(CreateDTO(section: "Descrição", showTitle: false, itens: array))
        
        return result
    }
}
