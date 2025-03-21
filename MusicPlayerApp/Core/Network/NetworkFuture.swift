//
//  NetworkFuture.swift
//  Network Manager Framework
//
//  Created by Agil Febrianistian on 04/02/19.
//  Copyright © 2019 agil. All rights reserved.
//

import Foundation
import PromiseKit
import Moya

class NetworkFuture<T> where T: Decodable {
    var network: NetworkBase!
    
    init(network: NetworkBase = NetworkBase()) {
        self.network = network
    }

    func request<U: NetworkTarget>(target: U) -> Promise<T> {
        return Promise { seal in
            self.network.request(target: target, success: { (data) in
                let decoder = JSONDecoder()
                do {
                    let value = try decoder.decode(T.self, from: data)
                    seal.fulfill(value)
                } catch {
                    let decodingError = NetworkError()
                    seal.reject(decodingError)
                }
            }, error: { (error) in
                seal.reject(error)
            })
        }
    }
}

extension NetworkFuture where T == Data {
    func request<U: NetworkTarget>(target: U) -> Promise<Data> {
        return Promise { seal in
            self.network.request(target: target, success: { (data) in
                seal.fulfill(data)
            }, error: { (error) in
                seal.reject(error)
            })
        }
    }
}
