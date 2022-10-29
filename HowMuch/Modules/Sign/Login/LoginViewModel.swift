//
//  LoginViewModel.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 10/09/22.
//

import Foundation
import RxSwift
import RxCocoa

enum LoginStates: SNStateful {
    case success(String)
    case loading(Bool)
    case error(String)
}

class LoginViewModel: SNViewModel<LoginStates> {
    // Inputs
    let login = PublishSubject<(email: String, password: String)>()
    let repository = AuthRepository.shared
//    fileprivate let repository = SNNetworkManager<SNLoginService>()
    var disposeBag = DisposeBag()
    
    override func configure() {
        login
            .subscribe(onNext: { [weak self] _ in
//                self?.repository.fetchAll()
                self?.repository.authenticate(with: "maatheusdavid@me.com", and: "123456") { [weak self] success in
                    if success {
                        FirestoreRepository.shared.fetchAll { sucess in
                            self?.emit(.success(""))
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

extension LoginViewModel {
}
