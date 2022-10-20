//
//  ViewController.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 10/09/22.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: SNViewController<LoginStates, LoginViewModel> {
    @IBOutlet weak var textFieldLogin: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonContinue: SNButton!
    var disposeBag = DisposeBag()
    var delegate: LoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonContinue.isEnabled = true
    }
    
    override func configureViews() {
        configureFields()
        linearBackground()
    }
    
    private func configureFields() {
    }
    
    override func configureBindings() {
        buttonContinue.rx
            .tap
            .withLatestFrom(textFieldLogin.rx.text)
            .withLatestFrom(textFieldPassword.rx.text,
                            resultSelector: {(email: $0 ?? "",
                                              password: $1 ?? "")})
            .bind(to: viewModel!.login)
            .disposed(by: disposeBag)
    }
    
    private func linearBackground() {
        let layer0 = CAGradientLayer()
        layer0.colors = [
          UIColor(red: 0, green: 0.925, blue: 0.757, alpha: 1).cgColor,
          UIColor(red: 0.004, green: 0.925, blue: 0.757, alpha: 0).cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0, y: 0)
        layer0.endPoint = CGPoint(x: 0.75, y: 0)
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0,
                                                                              b: 1,
                                                                              c: -1,
                                                                              d: 0,
                                                                              tx: 1,
                                                                              ty: 0))
        layer0.bounds = view.bounds.insetBy(dx: -1*view.bounds.size.width,
                                            dy: -0.5*view.bounds.size.height)
        layer0.position = view.center
        self.view.layer.addSublayer(layer0)
    }
    
    override func render(states: LoginStates) {
        switch states {
        case .success:
            delegate?.pushHome()
            delegate = nil
        case .loading(let loading):
            loading ? buttonContinue.showLoading() : buttonContinue.hideLoading()
        case .error:
            break
        }
    }
    
}

