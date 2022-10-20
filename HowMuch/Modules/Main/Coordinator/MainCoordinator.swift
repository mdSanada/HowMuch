//
//  MyReceiptCoordinator.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 10/09/22.
//

import UIKit
class MainCoordinator: SNCoordinator {
    var presenter: UIViewController
    var child: SNCoordinator?
    let tabController: TabController
    
    let myReceiptCoordinator: MyReceiptCoordinator
    let materialsCoordinator: MaterialsCoordinator
    let estimateCoordinator: EstimateCoordinator
    let settingsCoordinator: SettingsCoordinator

    lazy var storyboard: UIStoryboard = {
        return .init(name: "MainStoryboard", bundle: nil)
    }()
    
    deinit {
        Sanada.print("Deinitializing \(self)")
    }

    init(with navigation: UINavigationController) {
        self.presenter = navigation
        myReceiptCoordinator = MyReceiptCoordinator()
        materialsCoordinator = MaterialsCoordinator()
        estimateCoordinator = EstimateCoordinator()
        settingsCoordinator = SettingsCoordinator()
        
        tabController = UIStoryboard(name: "MainStoryboard",
                                               bundle: nil)
            .instantiateInitialViewController() as! TabController

        tabController.interface = self
        self.navigation?.setNavigationBarHidden(true, animated: false)
        self.navigation?.pushViewController(tabController, animated: false)
    }

    func start() {
        fatalError("You should restarStack to start MainCoordinator")
    }
    
    static func restartStack(navigation: UINavigationController = .init() ) {
        let coordinator = MainCoordinator(with: navigation)
        UIApplication.shared.keyWindow?.rootViewController = coordinator.presenter
    }

    func back() {
        self.navigation?.popViewController(animated: true)
    }
    
    func finish() {
        tabController.interface = nil
        myReceiptCoordinator.parent = nil
        materialsCoordinator.parent = nil
        estimateCoordinator.parent = nil
        settingsCoordinator.parent = nil
        LoginCoordinator.restartStack()
    }
}

extension MainCoordinator: TabProtocol {    
    func getViewController(_ viewController: RootViewControllers) -> UIViewController? {
        switch viewController {
        case .myReceipt:
            myReceiptCoordinator.parent = self
            return myReceiptCoordinator.presenter
        case .estimate:
            materialsCoordinator.parent = self
            return materialsCoordinator.presenter
        case .materials:
            estimateCoordinator.parent = self
            return estimateCoordinator.presenter
        case .settings:
            settingsCoordinator.parent = self
            return settingsCoordinator.presenter
        }
    }
}
