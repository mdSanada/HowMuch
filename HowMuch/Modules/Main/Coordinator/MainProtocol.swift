//
//  TabProtocol.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 14/09/22.
//

import Foundation
import UIKit

enum RootViewControllers {
    case myReceipt
    case estimate
    case materials
    case settings
}

protocol TabProtocol: AnyObject {
    func getViewController(_ viewController: RootViewControllers) -> UIViewController?
}
