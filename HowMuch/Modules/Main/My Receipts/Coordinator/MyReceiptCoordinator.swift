//
//  MyReceiptCoordinator.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 26/09/22.
//

import Foundation
import UIKit

class MyReceiptCoordinator: SNCoordinator {
    var parent: MainCoordinator?
    var presenter: UIViewController
    var child: SNCoordinator?
    
    lazy var storyboard: UIStoryboard = {
        return .init(name: "MainStoryboard", bundle: nil)
    }()
    
    deinit {
        Sanada.print("Deinitializing \(self)")
    }

    init() {
        let viewController = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MyReceiptViewController") as? MyReceiptViewController
        let navigation = UINavigationController(rootViewController: viewController!)
        viewController?.title = "Minhas Receitas"
        navigation.tabBarItem.image = UIImage.init(systemName: "list.bullet.rectangle.portrait")
        navigation.tabBarItem.title = "Receitas"
        navigation.navigationBar.prefersLargeTitles = true
        self.presenter = navigation
        viewController?.delegate = self
    }

    func start() {
    }

    func back() {
        self.navigation?.popViewController(animated: true)
    }
}
extension MyReceiptCoordinator: MyReceiptProtocol {
    func action() {
        parent?.finish()
        Sanada.print("teste")
    }
}
