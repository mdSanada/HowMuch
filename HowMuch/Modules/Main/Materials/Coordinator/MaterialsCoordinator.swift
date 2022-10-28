//
//  MaterialsCoordinator.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit

class MaterialsCoordinator: SNCoordinator {
    var parent: MainCoordinator?
    var presenter: UIViewController
    var child: SNCoordinator?
        
    lazy var storyboard: UIStoryboard = {
        return .init(name: "MainStoryboard", bundle: nil)
    }()
    
    lazy var materialStoryboard: UIStoryboard = {
        return .init(name: "MaterialStoryboard", bundle: nil)
    }()
    
    deinit {
        Sanada.print("Deinitializing \(self)")
    }

    init() {
        let viewController = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MaterialsViewController") as? MaterialsViewController
        let navigation = UINavigationController(rootViewController: viewController!)
        navigation.tabBarItem.image = UIImage.init(systemName: "bag")
        navigation.tabBarItem.title = "Materiais"
        navigation.navigationBar.prefersLargeTitles = true
        viewController?.title = "Materiais"
        self.presenter = navigation
        viewController?.delegate = self
    }

    func start() {
    }

    func back() {
        self.navigation?.popViewController(animated: true)
    }
}
extension MaterialsCoordinator: MaterialsProtocol {
    func create(type: MaterialsType) {
        let viewModel = MaterialCreateViewModel()
        let controller = materialStoryboard.instantiateViewController(identifier: "MaterialCreate") as? MaterialCreateViewController
        controller?.set(viewModel: viewModel)
        controller?.flow = .save
        controller?.type = type
        navigation?.present(controller!, animated: true)
    }
    
    func pushDetailed() {
    }
    
    func pushEdit(id: FirestoreId, type: MaterialsType) {
        let viewModel = MaterialCreateViewModel()
        let controller = materialStoryboard.instantiateViewController(identifier: "MaterialCreate") as? MaterialCreateViewController
        controller?.flow = .update(uuid: id)
        controller?.type = type
        controller?.set(viewModel: viewModel)
        navigation?.present(controller!, animated: true)
    }
}
