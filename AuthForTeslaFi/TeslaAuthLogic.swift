//
//  TeslaAuthLogic.swift
//  TeslaFi
//
//  Created by John on 11/9/21.
//

import Foundation
import OAuthSwift

class TeslaAuthLogic {
    let kTeslaClientID = "81527cff06843c8634fdc09e8ac0abefb46ac849f38fe1e431c2ef2106796384"
    let kTeslaSecret = "c7257eb71a564034f9419ee651c7d0e5f7aa6bfbd18bafb5c5c033b093bb2fa3"
    
    private(set) var tokenV3: Token?
    
    private static var sharedLogic: TeslaAuthLogic = {
        let logic = TeslaAuthLogic()
        return logic
    }()
    
    class func shared() -> TeslaAuthLogic {
        return sharedLogic
    }
    
    func clearToken() {
        tokenV3 = nil
    }
    
    private func verifier(forKey key: String) -> String {
        let verifier = key.data(using: .utf8)!.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
        return verifier
    }
    
    private func challenge(forVerifier verifier: String) -> String {
        let hash = verifier.sha256
        let challenge = hash.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
        return challenge
    }
    
    
    var credential: OAuthSwiftCredential?
    
    var oauthswift: OAuth2Swift? = nil
    
    func authenticateV3(region: TokenRegion, completion: @escaping (_ result: Token?) -> ()) {
        self.oauthswift = {
            switch region {
            case .global:
                // oauthswiftGlobal
                return OAuth2Swift(
                    consumerKey: "ownerapi",
                    consumerSecret: self.kTeslaSecret,
                    authorizeUrl: "https://auth.tesla.com/oauth2/v3/authorize",
                    accessTokenUrl: "https://auth.tesla.com/oauth2/v3/token",
                    responseType: "code"
                )
            case.china:
                // oauthswiftChina
                return OAuth2Swift(
                    consumerKey: "ownerapi",
                    consumerSecret: self.kTeslaSecret,
                    authorizeUrl: "https://auth.tesla.cn/oauth2/v3/authorize",
                    accessTokenUrl: "https://auth.tesla.cn/oauth2/v3/token",
                    responseType: "code"
                )
            }
        }()
        guard let oauthswift = self.oauthswift else { return }
        
        DispatchQueue.main.async {
            let codeVerifier = self.verifier(forKey: self.kTeslaClientID)
            let codeChallenge = self.challenge(forVerifier: codeVerifier)
            
            let internalController = AuthWebViewController()
            oauthswift.authorizeURLHandler = internalController
            let state = generateState(withLength: 20)
            
            oauthswift.authorize(withCallbackURL: "https://auth.tesla.com/void/callback", scope: "openid email offline_access", state: state, codeChallenge: codeChallenge, codeChallengeMethod: "S256", codeVerifier: codeVerifier) { result in
                switch result {
                case .success(let (credential, _, _)):
                    print("token: " + credential.oauthToken)
                    print("refresh token: " + credential.oauthRefreshToken)
                    
                    let token = Token(access_token: credential.oauthToken, token_type: "bearer", expires_in: 300, refresh_token: credential.oauthRefreshToken, expires_at: credential.oauthTokenExpiresAt, region: region)
                    self.tokenV3 = token
                    completion(token)
                    
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
            }
        }
    }
}
