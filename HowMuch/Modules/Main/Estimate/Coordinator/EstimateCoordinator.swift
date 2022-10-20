//
//  TreatmentCoordinator.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit

class EstimateCoordinator: SNCoordinator {
    var parent: MainCoordinator?
    var presenter: UIViewController
    var child: SNCoordinator?
        
    lazy var storyboard: UIStoryboard = {
        return .init(name: "MainStoryboard", bundle: nil)
    }()
    
    lazy var reminderStoryboard: UIStoryboard = {
        return .init(name: "RemindersStoryboard", bundle: nil)
    }()
    
    deinit {
        Sanada.print("Deinitializing \(self)")
    }

    init() {
        let viewController = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "EstimateViewController") as? EstimateViewController
        let navigation = UINavigationController(rootViewController: viewController!)
        navigation.tabBarItem.image = UIImage.init(systemName: "cart")
        navigation.tabBarItem.title = "Orçamentos"
        navigation.navigationBar.prefersLargeTitles = true
        viewController?.title = "Orçamentos"
        self.presenter = navigation
        viewController?.delegate = self
    }

    func start() {
    }

    func back() {
        self.navigation?.popViewController(animated: true)
    }
}
extension EstimateCoordinator: EstimateProtocol {
    func pushDetailed() {
    }
}
