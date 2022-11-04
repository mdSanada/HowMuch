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
    var presentNavigation: UINavigationController?
    
    lazy var storyboard: UIStoryboard = {
        return .init(name: "MainStoryboard", bundle: nil)
    }()
    
    lazy var saleStoryboard: UIStoryboard = {
        return .init(name: "SaleStoryboard", bundle: nil)
    }()
    
    deinit {
        Sanada.print("Deinitializing \(self)")
    }

    init() {
        let viewController = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MyReceiptViewController") as? MyReceiptViewController
        let navigation = UINavigationController(rootViewController: viewController!)
        viewController?.title = "Vendas"
        navigation.tabBarItem.image = UIImage.init(systemName: "list.bullet.rectangle.portrait")
        navigation.tabBarItem.title = "Vendas"
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
    func pushSaleDatailed() {
        guard let controller = saleStoryboard.instantiateViewController(identifier: "SaleDetailed") as? SaleDetailedViewController else { return }
        navigation?.pushViewController(controller, animated: true)
    }
    
    func presentSaleCreate() {
        let viewModel = SalesCreateViewModel()
        guard let controller = saleStoryboard.instantiateViewController(identifier: "SaleCreate") as? SalesCreateViewController else { return }
        controller.set(viewModel: viewModel)
        controller.flow = .save
        controller.delegate = self
        let newNavigation = UINavigationController(rootViewController: controller)
        presentNavigation = newNavigation
        navigation?.present(newNavigation, animated: true)
    }
    
    func pushSelectMaterial(type: MaterialsType) {
        let viewModel = SelectMaterialsViewModel(type: type)
        guard let controller = UIStoryboard(name: "MaterialStoryboard",
                                            bundle: nil).instantiateViewController(identifier: "SelectMaterials") as? SelectMaterialsViewController else { return }
        controller.delegate = self
        controller.set(viewModel: viewModel)
        presentNavigation?.pushViewController(controller, animated: true)
    }
}

extension MyReceiptCoordinator: SelectMaterialsProtocol {
    func pushQuantity(type: MaterialsType) {
        let viewModel = QuantityMaterialViewModel(type: type)
        guard let controller = UIStoryboard(name: "MaterialStoryboard",
                                            bundle: nil).instantiateViewController(identifier: "QuantityMaterial") as? QuantityMaterialViewController else { return }
        guard let backController = presentNavigation?.viewControllers.first as? SalesCreateViewController else { return }
        controller.delegate = self
        controller.selectDelegate = backController
        controller.set(viewModel: viewModel)
        presentNavigation?.pushViewController(controller, animated: true)
    }
}

extension MyReceiptCoordinator: QuantityMaterialProtocol {
    func pushAdded(type: MaterialsType, quantity: Double) {
        presentNavigation?.popToRootViewController(animated: true)
    }
    
    func popToRoot() {
        presentNavigation?.popToRootViewController(animated: true)
    }
}
