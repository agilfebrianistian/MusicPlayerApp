//
//  NetworkManager.swift
//  Network Manager Framework
//
//  Created by Agil Febrianistian on 04/02/19.
//  Copyright © 2019 agil. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    static var sharedInstance: NetworkManager = NetworkManager()
    static var networkApiDomain: String {
        return NetworkConstant.APIConstant.baseURL
    }
    
    let manager = Session(
        configuration: URLSessionConfiguration.default,
        serverTrustManager: nil
    )

    var token: String {
        let userDefault = UserDefaults.standard
        let token = userDefault.string(forKey: Keychain.accessToken.rawValue)
        return token ?? ""
    }
    
    func clearData() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
    
    var onRefreshToken:Bool=false
    var queueRequest = [Any]()

}

