//
//  AuthViewModel.swift
//  AuthAppForTesla
//
//  Created by John on 11/9/21.
//

import Foundation
import Intents

class AuthViewModel {
    var tokenV3: Token?
    var tokenV2: Token?
    
    init() {
        AuthController.shared().acquireTokenV3Silent { (token) in
            self.tokenV3 = token
            AuthController.shared().acquireTokenSilent { (token) in
                self.tokenV2 = token
            }
        }
    }
    
    public func refreshAll(onChange: @escaping () -> Void )
    {
        AuthController.shared().acquireTokenV3Silent(forceRefresh: true) { (token) in
            self.tokenV3 = token
            onChange()
            AuthController.shared().acquireTokenSilent(forceRefresh: true) { (token) in
                self.tokenV2 = token
                onChange()
            }
        }
    }

    public func logOut()
    {
        self.tokenV2 = nil
        self.tokenV3 = nil
        AuthController.shared().logOut()
    }
    
    func setJwtToken(_ token: Token)
    {
        AuthController.shared().setJwtToken(token)
        self.tokenV3 = token
    }
    
    func acquireTokenSilent(forceRefresh: Bool = false, _ completion: @escaping (Token?) -> ()) {
        AuthController.shared().acquireTokenSilent { (token) in
            self.tokenV2 = token
            if let tokenv3 = AuthController.shared().getV3Token(),
               let v3token = try? JSONDecoder().decode(Token.self, from: tokenv3)
            {
                self.tokenV3 = v3token
            }
            else
            {
                self.tokenV3 = nil
            }
            completion(token)
        }
    }

    func donateRefreshTokenInteraction() {
//        let intent = GetRefreshTokenIntent()
//
//        intent.suggestedInvocationPhrase = "Get refresh token"
//
//        let interaction = INInteraction(intent: intent, response: nil)
//
//        interaction.donate { (error) in
//            if error != nil {
//                if let error = error as NSError? {
//                    print("Interaction donation failed: \(error.description)")
//                } else {
//                    print("Successfully donated interaction")
//                }
//            }
//        }
    }

    func donateAccessTokenInteraction() {
//        let intent = GetAccessTokenIntent()
//
//        intent.suggestedInvocationPhrase = "Get access token"
//
//        let interaction = INInteraction(intent: intent, response: nil)
//
//        interaction.donate { (error) in
//            if error != nil {
//                if let error = error as NSError? {
//                    print("Interaction donation failed: \(error.description)")
//                } else {
//                    print("Successfully donated interaction")
//                }
//            }
//        }
    }
    
    func donateOwnersAccessTokenInteraction() {
//        let intent = GetOwnersAccessTokenIntent()
//
//        intent.suggestedInvocationPhrase = "Get owners access token"
//
//        let interaction = INInteraction(intent: intent, response: nil)
//
//        interaction.donate { (error) in
//            if error != nil {
//                if let error = error as NSError? {
//                    print("Interaction donation failed: \(error.description)")
//                } else {
//                    print("Successfully donated interaction")
//                }
//            }
//        }
    }

}
