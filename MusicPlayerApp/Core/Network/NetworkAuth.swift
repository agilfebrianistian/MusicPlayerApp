//
//  NetworkAuth.swift
//  Network Manager Framework
//
//  Created by Agil Febrianistian on 04/02/19.
//  Copyright © 2019 agil. All rights reserved.
//

import Foundation
import Moya

struct NetworkAuth: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let authorizable = target as? AccessTokenAuthorizable else { return request }
        let authorizationType = authorizable.authorizationType
        var request = request
        
        switch authorizationType {
        case .basic, .bearer:
            
            let authValue = "Bearer "+NetworkManager.sharedInstance.token
            request.addValue(authValue, forHTTPHeaderField: "Authorization")
            
        case .none:
            break
        case .custom(_):
            break
        }
        return request
    }
}
