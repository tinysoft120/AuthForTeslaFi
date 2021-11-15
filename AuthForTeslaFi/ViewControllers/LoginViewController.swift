//
//  LoginViewController.swift
//  AuthForTeslaFi
//
//  Created by John on 11/9/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var ivLogo: UIImageView!
    
    private lazy var authLogic: TeslaAuthLogic = {
        return TeslaAuthLogic.shared()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ivLogo.clipsToBounds = false
        ivLogo.layer.shadowColor = UIColor(named: "TeslaRed")!.cgColor
        ivLogo.layer.shadowOpacity = 0.2
        ivLogo.layer.shadowOffset = CGSize.zero
        ivLogo.layer.shadowRadius = 6
    }
    
    @IBAction func actionLoginWithTesla(_ sender: Any) {
        authLogic.clearToken()
        authLogic.authenticateV3(region: .global) { tokenV3 in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "idHomeViewController") as! HomeViewController
            vc.refreshToken = tokenV3?.refresh_token
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func actionLoginWithTeslaCn(_ sender: Any) {
        authLogic.clearToken()
        authLogic.authenticateV3(region: .china) { tokenV3 in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "idHomeViewController") as! HomeViewController
            vc.refreshToken = tokenV3?.refresh_token
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}

