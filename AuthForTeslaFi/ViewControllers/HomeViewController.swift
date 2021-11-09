//
//  HomeViewController.swift
//  AuthForTeslaFi
//
//  Created by John on 11/9/21.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var lblRefreshToken: UILabel!
    @IBOutlet weak var vRefreshTokenView: UIView!
    @IBOutlet weak var ivMark: UIImageView!
    
    private lazy var model: AuthViewModel = AuthViewModel()
    
    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    private let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    private var refreshToken: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ivMark.clipsToBounds = false
        ivMark.layer.shadowColor = UIColor.gray.cgColor
        ivMark.layer.shadowOpacity = 0.2
        ivMark.layer.shadowOffset = CGSize.zero
        ivMark.layer.shadowRadius = 2
        lblVersion.text = "Ver. \(version) build \(build)"
        guard let token = model.tokenV3?.refresh_token else {
            DispatchQueue.main.async { [self] in
                dismiss(animated: true, completion: nil)
            }
            return
        }
        lblRefreshToken.text = token
        refreshToken = token
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionCopyToken(_:)))
        vRefreshTokenView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func actionCopyToken(_ sender: UITapGestureRecognizer) {
        
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = refreshToken
        animateCheck()
    }
    
    @IBAction func actionRefreshToken(_ sender: Any) {
    }
    
    @IBAction func actionSendEmail(_ sender: Any) {
    }
    
    @IBAction func actionSendSMS(_ sender: Any) {
    }
    
    @IBAction func actionGotoTeslaFi(_ sender: Any) {
    }
    
    private func animateCheck() {
        
    }
}

