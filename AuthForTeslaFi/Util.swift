//
//  Util.swift
//  AuthAppForTesla
//
//  Created by John on 11/9/21.
//

import Foundation
import CryptoKit
import SwiftDate

extension CGSize {
    var least: CGFloat {
        return self.width < self.height ? self.width : self.height
    }
    var most: CGFloat {
        return self.width < self.height ? self.height : self.width
    }
}

extension String {
    var sha256:String {
           get {
            let inputData = Data(self.utf8)
            let hashed = SHA256.hash(data: inputData)
            let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
            return hashString
           }
       }
    
    func base64EncodedString() -> String {
        let inputData = Data(self.utf8)
        return inputData.base64EncodedString()
    }
}

extension KeychainWrapper {
    public static let global = KeychainWrapper.standard // KeychainWrapper.init(serviceName: "AuthForTeslaFi", accessGroup: "group.global", iCloudSync: true)
}

extension UserDefaults {
    public static let standard = UserDefaults.standard  // UserDefaults.init(suiteName: "group.global")!
}

