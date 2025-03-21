//
//  NetworkAPI.swift
//  Network Manager Framework
//
//  Created by Agil Febrianistian on 04/02/19.
//  Copyright © 2019 agil. All rights reserved.
//

import UIKit
import Moya
import Foundation

enum NetworkAPI {
    case getSongList(param: SongParameter)
}

// MARK: - TargetType Protocol Implementation
extension NetworkAPI: NetworkTarget {
    var baseURL: URL {
        return URL(string: NetworkConstant.APIConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getSongList:
            return "search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getSongList(let param):
            return .requestParameters(parameters: param.asDictionary ?? [:],
                                      encoding: URLEncoding.default)

        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return "".utf8Encoded
        }
    }
    
    var headers: [String: String]? {
        return ["Accept":"application/json"]
    }
    
}

extension NetworkAPI: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        default :
            return .basic
        }
    }
}
