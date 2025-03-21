//
//  Extension+StringEncoding.swift
//  MusicPlayerApp
//
//  Created by Agil Febrianistian on 21/03/25.
//

import Foundation

extension String {
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
    
    var urlEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var plusnEncodedString: String {
        let encodedString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodedString?.replacingOccurrences(of: "%20", with: "+") ?? ""
    }
}
