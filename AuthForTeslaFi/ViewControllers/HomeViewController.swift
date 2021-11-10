//
//  HomeViewController.swift
//  AuthForTeslaFi
//
//  Created by John on 11/9/21.
//

import UIKit
import MBProgressHUD

class HomeViewController: UIViewController {
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var lblRefreshToken: UILabel!
    @IBOutlet weak var vRefreshTokenView: UIView!
    
    private lazy var model: AuthViewModel = AuthViewModel()
    
    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    private let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    private var refreshToken: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblVersion.text = "Ver. \(version) build \(build)"
        updateToken()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionCopyToken(_:)))
        vRefreshTokenView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func actionCopyToken(_ sender: UITapGestureRecognizer) {
        
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = refreshToken
        animateCheck()
    }
    
    @IBAction func actionRefreshToken(_ sender: Any) {
        model.refreshAll {
            self.updateToken()
        }
    }
    
    @IBAction func actionSendEmail(_ sender: Any) {
    }
    
    @IBAction func actionSendSMS(_ sender: Any) {
    }
    
    @IBAction func actionLinkToTeslaFi(_ sender: Any) {
    }
    
    private func updateToken() {
        guard let token = model.tokenV3?.refresh_token else {
            DispatchQueue.main.async { [self] in
                dismiss(animated: true, completion: nil)
            }
            return
        }
        lblRefreshToken.text = token
        refreshToken = token
    }
    
    private func animateCheck() {
        let color = UIColor.black  //UIColor(named: "TeslaRed")!
        let image = UIImage(named: "Checkmark")!.withTintColor(color)
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .customView
        hud.customView = UIImageView(image: image)
        hud.isSquare = true
        hud.label.text = "Copied!"
        hud.contentColor = color
        hud.hide(animated: true, afterDelay: 0.8)
    }
}

