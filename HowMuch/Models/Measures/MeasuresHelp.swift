//
//  MeasuresHelp.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 09/11/22.
//

import Foundation
/*
 type: WEIGHT
 default: GRAMS

 type: LIQUID
 default: MILLILITER
 
 type: PERCENT
 default: PERCENT
 
 type: UNIT
 default: UNIT
 */

struct MeasuresJSON {
    static let types: String = """
[{
    "type": "WEIGHT",
    "defaultMesure": "GRAMS"
}, {
    "type": "LIQUID",
    "defaultMesure": "MILLILITER"
}, {
    "type": "PERCENT",
    "defaultMesure": "PERCENT"
}, {
    "type": "UNIT",
    "defaultMesure": "UNIT"
}]
"""
    
    /*
     type: WEIGHT
     mesure: GRAMS
     ratio: 1
     
     type: WEIGHT
     mesure: KILOGRAMS
     ratio: 1000

     type: WEIGHT
     mesure: MILLIGRAMS
     ratio: 0.001

     type: WEIGHT
     mesure: UNIT
     ratio: nil

     type: LIQUID
     mesure: MILLILITER
     ratio: 1
     
     type: LIQUID
     mesure: LITER
     ratio: 1000

     type: LIQUID
     mesure: UNIT
     ratio: nil

     type: PERCENT
     mesure: PERCENT
     ratio: nil
     
     type: UNIT
     mesure: UNIT
     ratio: nil
     */
    static let measures: String = """
[{
    "type": "WEIGHT",
    "mesure": "GRAMS",
    "ratio": 1
}, {
    "type": "WEIGHT",
    "mesure": "KILOGRAMS",
    "ratio": 1000
}, {
    "type": "WEIGHT",
    "mesure": "MILLIGRAMS",
    "ratio": 0.001
}, {
    "type": "WEIGHT",
    "mesure": "UNIT"
}, {
    "type": "LIQUID",
    "mesure": "MILLILITER",
    "ratio": 1
}, {
    "type": "LIQUID",
    "mesure": "LITER",
    "ratio": 1000
}, {
    "type": "LIQUID",
    "mesure": "UNIT"
}, {
    "type": "PERCENT",
    "mesure": "PERCENT"
}, {
    "type": "UNIT",
    "mesure": "UNIT"
}]
"""
}
