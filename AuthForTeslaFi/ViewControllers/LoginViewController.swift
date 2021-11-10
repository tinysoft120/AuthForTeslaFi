//
//  LoginViewController.swift
//  AuthForTeslaFi
//
//  Created by John on 11/9/21.
//

import UIKit
import OAuthSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var ivLogo: UIImageView!
    
    private lazy var model: AuthViewModel = AuthViewModel()
    private var region: TokenRegion = .global
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ivLogo.clipsToBounds = false
        ivLogo.layer.shadowColor = UIColor(named: "TeslaRed")!.cgColor
        ivLogo.layer.shadowOpacity = 0.2
        ivLogo.layer.shadowOffset = CGSize.zero
        ivLogo.layer.shadowRadius = 6
    }
    
    @IBAction func actionSegmentedControlChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: region = .global
        case 1: region = .china
        default: break;
        }
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        model.logOut()
        self.authenticateV3()
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
    
    func authenticateV3() {
        
        AuthController.shared().getAuthRegion(region: self.region) { (url) in
            guard let url = url else { return }
            
            self.oauthswift = {
                switch self.region {
                case .global:
                    // oauthswiftGlobal
                    return OAuth2Swift(
                        consumerKey: "ownerapi",
                        consumerSecret: kTeslaSecret,
                        authorizeUrl: "https://auth.tesla.com/oauth2/v3/authorize",
                        accessTokenUrl: url,
                        responseType: "code"
                    )
                case.china:
                    // oauthswiftChina
                    return OAuth2Swift(
                        consumerKey: "ownerapi",
                        consumerSecret: kTeslaSecret,
                        authorizeUrl: "https://auth.tesla.cn/oauth2/v3/authorize",
                        accessTokenUrl: url,
                        responseType: "code"
                    )
                }
            }()
            guard let _ = self.oauthswift else { return }
            
            DispatchQueue.main.async { [self] in
                let codeVerifier = self.verifier(forKey: kTeslaClientID)
                let codeChallenge = self.challenge(forVerifier: codeVerifier)
                
                let internalController = AuthWebViewController()
                oauthswift!.authorizeURLHandler = internalController
                let state = generateState(withLength: 20)
                
                oauthswift!.authorize(withCallbackURL: "https://auth.tesla.com/void/callback", scope: "openid email offline_access", state: state, codeChallenge: codeChallenge, codeChallengeMethod: "S256", codeVerifier: codeVerifier) { result in
                    switch result {
                    case .success(let (credential, _, _)):
                        print("token: " + credential.oauthToken)
                        print("refresh token: " + credential.oauthRefreshToken)
                        
                        let token = Token(access_token: credential.oauthToken, token_type: "bearer", expires_in: 300, refresh_token: credential.oauthRefreshToken, expires_at: credential.oauthTokenExpiresAt, region: self.region)
                        model.setJwtToken(token)
                        
                        if let encodedToken = try? JSONEncoder().encode(token) {
                            print("V3 token from setJwtToken: \(encodedToken)")
                            KeychainWrapper.global.set(encodedToken, forKey: kTokenV3, withAccessibility: .afterFirstUnlock)
                        }
                        
                        // close it since no need silent token - tokenV2
                        //model.acquireTokenSilent(forceRefresh: true) { (token) in
                        //}
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idHomeViewController") as! HomeViewController
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
        }
    }

}

