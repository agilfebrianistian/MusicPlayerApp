//
//  NetworkBase.swift
//  Network Manager Framework
//
//  Created by Agil Febrianistian on 04/02/19.
//  Copyright © 2019 agil. All rights reserved.
//

import Foundation
import Moya

typealias NetworkSuccessCompletion = (Data) -> Void
typealias NetworkErrorCompletion = (NetworkError) -> Void
typealias NetworkTarget = TargetType

class NetworkBase {
    
    static var networkProvider = MoyaProvider<NetworkAPI>(session: NetworkManager.sharedInstance.manager, plugins: [NetworkAuth(),NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose)),MoyaCacheablePlugin()])

    
    func request<T: NetworkTarget>(target: T,
                                   success: @escaping NetworkSuccessCompletion,
                                   error: @escaping NetworkErrorCompletion) {
        switch target {
        case is NetworkAPI:
            NetworkBase.networkProvider.request(target as! NetworkAPI) { (result) in
                self.handleRequest(target: target,
                                   result: result,
                                   success: success,
                                   error: error)
            }
        default:
            assertionFailure("should not reach here")
        }
    }
    
    private func handleRequest<T: NetworkTarget>(target: T,
                                                 result: Result<Moya.Response, MoyaError>,
                                                 success: @escaping NetworkSuccessCompletion,
                                                 error: @escaping NetworkErrorCompletion) {
        switch result {
        case let .success(moyaResponse):
            let data = moyaResponse.data
            let statusCode = moyaResponse.statusCode
            
            switch statusCode {
            case 200...399:
                success(data)
            default:
                handleNetworkError(target.path, error: error, response: moyaResponse)
            }
        case let .failure(networkError):
            
            var networkErrorData = NetworkError()
            networkErrorData.errorMessage = networkError.localizedDescription
            error(networkErrorData)
        }
    }
    
    private func handleNetworkError(_ path: String,
                                    error: NetworkErrorCompletion,
                                    response: Moya.Response?) {
        let networkError = NetworkBase.generateError(with: response)
        error(networkError)
    }
}

struct NetworkRequest<T:NetworkTarget>{
    let target:T
    let success:NetworkSuccessCompletion
    let error:NetworkErrorCompletion
}

extension NetworkBase {
        
    static func generateError(with response: Moya.Response?) -> NetworkError {
        do {
            let json = try? JSONSerialization.jsonObject(with: response?.data ?? Data(), options: [])
            print("json %@", json ?? [:])
            
            let decoder = JSONDecoder()
            let networkError = try decoder.decode(NetworkError.self, from: response?.data ?? Data())
            return networkError
        } catch {
            let dataString = String(data: response?.data ?? Data(), encoding: String.Encoding.utf8)
            var error = NetworkError()
            error.errorMessage = dataString
            return error
        }
    }
}
