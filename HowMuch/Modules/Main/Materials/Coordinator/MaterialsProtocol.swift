//
//  PatientsProtocol.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import Foundation

protocol MaterialsProtocol: AnyObject {
    func create(type: MaterialsType)
    func pushDetailed(id: FirestoreId, type: MaterialsType)
    func presentDetailed(id: FirestoreId, type: MaterialsType)
    func pushEdit(id: FirestoreId, type: MaterialsType)
    func presentEdit(id: FirestoreId, type: MaterialsType)
}
