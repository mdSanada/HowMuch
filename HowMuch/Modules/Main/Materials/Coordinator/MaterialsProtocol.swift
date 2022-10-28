//
//  PatientsProtocol.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import Foundation

protocol MaterialsProtocol: AnyObject {
    func create(type: MaterialsType)
    func pushDetailed()
    func pushEdit(id: FirestoreId, type: MaterialsType)
}
