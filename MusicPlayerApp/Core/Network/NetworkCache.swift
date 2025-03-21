//
//  NetworkCache.swift
//  Network
//
//  Created by Agil Febrianistian on 1/28/21.
//

import Foundation
import Moya

protocol MoyaCacheable {
    typealias MoyaCacheablePolicy = URLRequest.CachePolicy
    var cachePolicy: MoyaCacheablePolicy { get }
}

final class MoyaCacheablePlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let moyaCachableProtocol = target as? MoyaCacheable {
            var cachableRequest = request
            cachableRequest.cachePolicy = moyaCachableProtocol.cachePolicy
            if moyaCachableProtocol.cachePolicy == .reloadIgnoringLocalAndRemoteCacheData{
                cachableRequest.addValue("no-cache, no-store, max-age=0, must-revalidate", forHTTPHeaderField: "Cache-Control")
                cachableRequest.httpShouldHandleCookies = false
            }
            return cachableRequest
            
        }
        return request
    }
}
