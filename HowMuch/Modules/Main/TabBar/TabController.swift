//
//  TabController.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 14/09/22.
//

import UIKit

class TabController: UITabBarController {
    var interface: TabProtocol?
    
    deinit {
        Sanada.print("Deinitializing \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        addBlurEffect()
    }
    
    private func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBar.insertSubview(blurView, at: 0)
        
        blurView.snp.makeConstraints { make in
            make.trailing.leading.top.bottom.equalToSuperview()
        }
    }
    
    private func configureViewControllers() {
        guard let interface = interface else {
            return
        }
        
        let myReceipt = interface.getViewController(.myReceipt)
        
        let estimate = interface.getViewController(.estimate)

        let materials = interface.getViewController(.materials)

        let settings = interface.getViewController(.settings)
        
        let listViewControllers = [myReceipt, materials,/* estimate,*/ settings]

        viewControllers = listViewControllers.compactMap { $0 }
    }
}
