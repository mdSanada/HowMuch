//
//  LoginRepository.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 10/09/22.
//

import UIKit
import RxSwift
import Moya
import Resolver
import RxSwiftExt

internal enum SNLoginService: SNNetworkTask {
    case login
}

extension SNLoginService {
    var baseURL: SNNetworkBaseURL {
        return .normal
    }
    
    var path: String {
        switch self {
        case .login:
            return "api/v1/login"
        }
    }
    
    var method: SNNetworkMethod {
        switch self {
        case .login:
            return .get
        }
    }
    
    var params: [String : Any] {
        switch self {
        case .login:
            return [:]
        }
    }
    
    var encoding: EncodingMethod {
        switch self {
        case .login:
            return .queryString
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login:
            return [:]
        }
    }
}
