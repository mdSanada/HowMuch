//
//  TimeType.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 25/10/22.
//

import Foundation

enum TimeType: String, CaseIterable {
    case min = "MINUTE"
    case hour = "HOUR"
}

extension TimeType: MenuProtocol {
    func dict() -> [String : String] {
        TimeType.dict()
    }
    
    func defaultValue() -> String {
        return dict()[self.rawValue] ?? ""
    }

    static func dict() -> [String: String] {
        var dict: [String: String] = [:]
        TimeType.allCases.forEach { time in
            switch time {
            case .min:
                return dict[time.rawValue] = "min"
            case .hour:
                return dict[time.rawValue] = "h"
            }
        }
        return dict
    }
}
