//
//  NetworkSession.swift
//  Network Manager Framework
//
//  Created by Agil Febrianistian on 06/02/19.
//  Copyright © 2019 agil. All rights reserved.
//

import Foundation

enum Keychain: String {
    case accessToken
    case refreshToken
    case user
    func toString() -> String {
        return self.rawValue
    }
}

class NetworkSession {
    static var sharedInstance: NetworkSession = NetworkSession()
    
    var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: Keychain.accessToken.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keychain.accessToken.rawValue)
        }
    }
    
    var refreshToken: String? {
        get {
            return UserDefaults.standard.string(forKey: Keychain.refreshToken.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keychain.refreshToken.rawValue)
        }
    }
    
    
    func clearData() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }

}
