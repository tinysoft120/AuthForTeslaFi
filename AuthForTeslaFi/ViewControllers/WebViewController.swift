//
//  WebViewController.swift
//  AuthForTeslaFi
//
//  Created by John on 11/10/21.
//

import UIKit
import WebKit
import MBProgressHUD

class WebViewController: UIViewController {
    private let TELSAFI_URL = "https://www.teslafi.com/userlogin.php"  //"https://www.teslafi.com/postTest.php"  //
    
    @IBOutlet weak var webViewContainer: UIView!
    
    var _refreshToken: String?
    private var refreshToken: String {
        get { return _refreshToken ?? "" }
    }
    
    private lazy var wkWebView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let webview = WKWebView(frame: CGRect.zero, configuration: configuration)
        webview.navigationDelegate = self
        webview.uiDelegate = self
        webview.scrollView.bounces = false
        return webview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webViewContainer.addSubview(wkWebView)
        
        loadWebView(refreshToken)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        wkWebView.topAnchor.constraint(equalTo: webViewContainer.topAnchor).isActive = true
        wkWebView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor).isActive = true
        wkWebView.leftAnchor.constraint(equalTo: webViewContainer.leftAnchor).isActive = true
        wkWebView.rightAnchor.constraint(equalTo: webViewContainer.rightAnchor).isActive = true
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        //wkWebView.layer.borderWidth = 1.0
        //wkWebView.layer.borderColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
    }
    
    private func loadWebView(_ token: String) {
        let body = "refresh_token=\(token)"
        var request = URLRequest(url: URL(string: TELSAFI_URL)!)
        let postData = body.data(using: .utf8)!
        let contentLength = "\(postData.count)"
        request.httpMethod = "POST"
        request.httpBody = postData
        request.setValue(contentLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded charset=utf-8", forHTTPHeaderField: "Content-Type")
        //request.setValue("application/json", forHTTPHeaderField: "Accept")
        wkWebView.load(request)
    }
}

extension WebViewController: WKNavigationDelegate, WKUIDelegate {
    // MARK: - WKNavigationDelegate Methods

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let currentURL = webView.url?.absoluteString ?? ""
        print("WebViewController: Web Loading Start. URL=\(currentURL)")
        if (currentURL.isEmpty) {
            DispatchQueue.main.async { [self] in
                dismiss(animated: true, completion: nil)
            }
        }
        //MBProgressHUD.showAdded(to: view, animated: true)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let currentURL = webView.url?.absoluteString
        print("WebViewController: Web Loading Finish. URL=\(currentURL ?? "")")
        
        //MBProgressHUD.hide(for: view, animated: true)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        //let requestedURL = navigationAction.request.url
        //if let requestedURL = requestedURL {
        //    let strUrl = requestedURL.absoluteString
        //    print("WebViewController: Web Request URL=\(strUrl)")
        //    if navigationAction.navigationType == .linkActivated {
        //        if UIApplication.shared.canOpenURL(requestedURL) {
        //            UIApplication.shared.open(requestedURL)
        //        }
        //        decisionHandler(.cancel)
        //        return
        //    }
        //}
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let currentURL = webView.url?.absoluteString
        print("WebViewController: Web Loading failed. URL=\(currentURL ?? "")  ERROR:\(error.localizedDescription)")
        //MBProgressHUD.hide(for: view, animated: true)
    }
    
    // MARK: - WKUIDelegate Methods
}

