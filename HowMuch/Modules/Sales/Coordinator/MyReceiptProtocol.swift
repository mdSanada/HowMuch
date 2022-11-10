//
//  MyReceiptProtocol.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 26/09/22.
//

import Foundation

protocol MyReceiptProtocol: AnyObject {
    func pushSaleDatailed()
    func presentSaleCreate()
    func pushSelectMaterial(type: MaterialsType)
    func dismissFromParent()
}
