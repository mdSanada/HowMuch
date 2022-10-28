//
//  AuthRepository.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 28/10/22.
//

import Foundation

import Foundation
import FirebaseCore
import FirebaseAuth

class AuthRepository {
    static public let shared = AuthRepository()
    
    public func authenticate(with email: String, and password: String, completion: @escaping ((Bool) -> ())) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard error == nil, let user = authResult else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func token() -> String? {
        let auth = Auth.auth().currentUser?.uid
        return auth
    }
    
    public func isLogged() -> Bool {
        return Auth.auth().currentUser != nil
    }
}
