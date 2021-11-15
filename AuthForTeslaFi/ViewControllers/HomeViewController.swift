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
    
    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    private let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    var refreshToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblVersion.text = "Ver. \(version) build \(build)"
        updateToken()
    }
    
    @IBAction func actionCopyToken(_ sender: Any) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = refreshToken
        animateCheck()
    }
    
    //@IBAction func actionRefreshToken(_ sender: Any) {
    //    model.refreshAll {
    //        self.updateToken()
    //    }
    //}
    
    @IBAction func actionLinkToTeslaFi(_ sender: Any) {
        //let link = "https://www.teslafi.com/index.php?refresh_token=\(self.refreshToken)"
        //if let url = URL(string: link) {
        //    UIApplication.shared.open(url)
        //}
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idWebViewController") as! WebViewController
        vc.modalPresentationStyle = .fullScreen
        vc._refreshToken = refreshToken
        vc._authType = .login
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func actionSignToTeslaFi(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idWebViewController") as! WebViewController
        vc.modalPresentationStyle = .fullScreen
        vc._refreshToken = refreshToken
        vc._authType = .signup
        self.present(vc, animated: true, completion: nil)
    }
    
    private func updateToken() {
        guard let token = refreshToken else {
            DispatchQueue.main.async { [self] in
                dismiss(animated: true, completion: nil)
            }
            return
        }
        lblRefreshToken.text = token
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

