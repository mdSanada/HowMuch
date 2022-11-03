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
        let viewModel = MaterialsViewModel()
        let viewController = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MaterialsViewController") as? MaterialsViewController
        viewController?.set(viewModel: viewModel)
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
    
    func pushDetailed(id: FirestoreId, type: MaterialsType) {
        let viewModel = MaterialDetailedViewModel(id: id, type: type)
        guard let controller = materialStoryboard.instantiateViewController(identifier: "MaterialDetailed") as? MaterialDetailedViewController else { return }
        controller.set(viewModel: viewModel)
        controller.delegate = self
        navigation?.pushViewController(controller, animated: true)
    }
    
    func presentDetailed(id: FirestoreId, type: MaterialsType) {
        let viewModel = MaterialDetailedViewModel(id: id, type: type)
        let controller = materialStoryboard.instantiateViewController(identifier: "MaterialDetailed") as? MaterialDetailedViewController
        controller?.set(viewModel: viewModel)
        controller?.delegate = self
        navigation?.present(controller!, animated: true)
    }
    
    func presentEdit(id: FirestoreId, type: MaterialsType) {
        let viewModel = MaterialCreateViewModel()
        let controller = materialStoryboard.instantiateViewController(identifier: "MaterialCreate") as? MaterialCreateViewController
        controller?.flow = .update(uuid: id)
        controller?.type = type
        controller?.set(viewModel: viewModel)
        navigation?.present(controller!, animated: true)
    }
    
    func pushEdit(id: FirestoreId, type: MaterialsType) {
        let viewModel = MaterialCreateViewModel()
        guard let controller = materialStoryboard.instantiateViewController(identifier: "MaterialCreate") as? MaterialCreateViewController else { return }
        controller.flow = .update(uuid: id)
        controller.type = type
        controller.set(viewModel: viewModel)
        navigation?.pushViewController(controller, animated: true)
    }
    
    func dismiss() {
        self.navigation?.dismiss(animated: true, completion: nil)
    }
    
    func popToRoot() {
        self.navigation?.popToRootViewController(animated: true)
    }
    
    func showDeleteAlert(handler: @escaping (() -> ())) {
        let viewModel = AlertViewModel()
        let controller = AlertViewController.create(with: viewModel)
        controller.set(viewModel: viewModel)
        
        controller.text = (title: "Atenção", description: "Ao apagar este item, qualquer irá apagar de qualquer lugar que é utilizado")
        controller.action = (title: "Deletar", color: .red)
        controller.dismiss = (title: "Cancelar", color: .clear)
        controller.setup(handler: handler)
        controller.modalPresentationStyle = .overCurrentContext
        parent?.navigation?.present(controller, animated: false, completion: nil)
    }
}
