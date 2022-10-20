//
//  Servie.swift
//  Template
//
//  Created by Matheus D Sanada on 22/09/21.
//

import Foundation
import RxSwift
import Moya

public enum Service {
    case teste(String)
}

extension Service: TargetType {
    public var baseURL: URL {
        switch self {
        default:
            return URL(string: "https://5fca33b63c1c220016441e38.mockapi.io/api/v1/")!
        }
    }
    
    public var path: String {
        switch self {
        case .teste:
            return "fake"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    public var sampleData: Data {
        return .init()
    }
    
    public var task: Task {
        var params: [String: Any] = [:]
        switch self {
        default:
            break
        }
        
        switch self {
        default:
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String: String]? {
        guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return nil }
        return["product": "maximadigital",
                        "x-correlation-id": UUID().uuidString,
                        "versionCode": version]
    }
}

