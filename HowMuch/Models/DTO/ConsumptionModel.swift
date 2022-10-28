//
//  ConsumptionModel.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation

// MARK: - ConsumptionModel
struct ConsumptionModel: Codable {
    var name, consumptionDescription, level: String?
    var time: Double?
    var measurement: String?
    var consumption: String?

    enum CodingKeys: String, CodingKey {
        case name
        case consumptionDescription = "description"
        case measurement
        case level, time, consumption
    }
    
    internal init(name: String? = nil, consumptionDescription: String? = nil, measurement: String? = nil, level: String? = nil, time: Double? = nil, consumption: String? = nil) {
        self.name = name
        self.consumptionDescription = consumptionDescription
        self.level = level
        self.measurement = measurement
        self.time = time
        self.consumption = consumption
    }
}

extension ConsumptionModel: Creatable {
    static func editable(model: ConsumptionModel) -> [CreateDTO] {
        var result:[CreateDTO] = []
        var array:[CreateType]  = []
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: ConsumptionModel.CodingKeys.name.rawValue,
                                                                                  title: "Nome",
                                                                                  placeholder: "Nome",
                                                                                  initial: model.name,
                                                                                  textFieldType: .text,
                                                                                  type: .title))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: ConsumptionModel.CodingKeys.consumptionDescription.rawValue,
                                                                                  title: "Descrição",
                                                                                  placeholder: "Descrição",
                                                                                  initial: model.consumptionDescription,
                                                                                  textFieldType: .text,
                                                                                  type: .body))))
        
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: nil,
                                                                                  title: "Consumo",
                                                                                  placeholder: "",
                                                                                  initial: nil,
                                                                                  textFieldType: .text,
                                                                                  type: .menu(key: ConsumptionModel.CodingKeys.consumption.rawValue,
                                                                                              actions: ConsumptionType.allCases.map { $0.rawValue },
                                                                                              initial: model.consumption ?? ConsumptionType.gas.rawValue,
                                                                                              hiddenInput: true)))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: nil,
                                                                                  title: "Nível",
                                                                                  placeholder: "",
                                                                                  initial: nil,
                                                                                  textFieldType: .currency,
                                                                                  type: .menu(key: ConsumptionModel.CodingKeys.level.rawValue,
                                                                                              actions: NivelType.allCases.map { $0.rawValue },
                                                                                              initial: model.level ?? NivelType.low.rawValue,
                                                                                              hiddenInput: true)))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: ConsumptionModel.CodingKeys.time.rawValue,
                                                                                  title: "Tempo",
                                                                                  placeholder: "Tempo",
                                                                                  initial: nil,
                                                                                  textFieldType: .number,
                                                                                  type: .menu(key: ConsumptionModel.CodingKeys.measurement.rawValue,
                                                                                              actions: TimeType.allCases.map { $0.rawValue },
                                                                                              initial: model.measurement ?? TimeType.min.rawValue,
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
                                                                                              actions: ConsumptionType.allCases.map { $0.rawValue },
                                                                                              initial: ConsumptionType.gas.rawValue,
                                                                                              hiddenInput: true)))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: nil,
                                                                                  title: "Nível",
                                                                                  placeholder: "",
                                                                                  initial: nil,
                                                                                  textFieldType: .currency,
                                                                                  type: .menu(key: ConsumptionModel.CodingKeys.level.rawValue,
                                                                                              actions: NivelType.allCases.map { $0.rawValue },
                                                                                              initial: NivelType.low.rawValue,
                                                                                              hiddenInput: true)))))
        array.append(CreateType.text(TextFieldViewModelCell(item: CreateTextModel(key: ConsumptionModel.CodingKeys.time.rawValue,
                                                                                  title: "Tempo",
                                                                                  placeholder: "Tempo",
                                                                                  initial: nil,
                                                                                  textFieldType: .number,
                                                                                  type: .menu(key: ConsumptionModel.CodingKeys.measurement.rawValue,
                                                                                              actions: TimeType.allCases.map { $0.rawValue },
                                                                                              initial: TimeType.min.rawValue,
                                                                                              hiddenInput: false)))))
        
        
        result.append(CreateDTO(section: "Descrição", showTitle: false, itens: array))
        
        return result
    }
}
