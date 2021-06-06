//
//  ViewController.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import UIKit
import WebKit


class HomeViewController: UIViewController,WKNavigationDelegate,WKUIDelegate,Storyboarded {
    
    @IBOutlet var homeWebView: WKWebView!
    let contentController = WKUserContentController()
    let configuration = WKWebViewConfiguration()
    
    var generatedHtml : String?
    var receivedContent: String? = ""
    var viewModel = HomeViewModel()
    var categoriesCoordinator: CategoryCoordinator?
    
    
    init(viewModel: HomeViewModel ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
     
    override func viewWillAppear(_ animated: Bool) {
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        configuration.preferences = preferences
        configuration.userContentController = contentController
        
        let url = Bundle.main.url(forResource: "ListView", withExtension: "html")!
        homeWebView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        
        homeWebView.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeWebView.navigationDelegate = self
        homeWebView.uiDelegate = self
        
        fetchData()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: Notification.Name("RetryServiceNotificationIdentifier"), object: nil)
        
    }
    
    @objc func fetchData() {
        let body = [ "limit" : 9,
                     "offset" : 6] as [String : Int]
        
        API.shared.service(from: body, router: .home) { result in
            switch result {
            case .fail(_):
                print("fail")
            case .success(let data):
                print("success")
                self.viewModel.show(with: data)
                
            }
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        homeWebView.injectJS(resource: "Script-functions", type: "js")
        if let filepath = Bundle.main.path(forResource: "Style", ofType: "css") {
            if let str = try? String(contentsOfFile: filepath) {
                webView.injectCSS(string: str, suffixIdentifier: "Style")
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.personsBehavior.subscribe{ element in
            let value = element.map{ return $0 }
            if let fullname = value.element?.fullname, let birthdate = value.element?.commentaire{
                self.homeWebView.evaluateJavaScript("createTable([['\(fullname)'], ['\(birthdate)']]);")
            }            
        }.disposed(by: viewModel.disposeBag)

    }

    @IBAction func showCategories(sender: UIBarButtonItem) {
        if let navigationController = self.navigationController {
            categoriesCoordinator = CategoryCoordinator(navigationController: navigationController, categoris: [])
            categoriesCoordinator?.start()
        }
    }
    
}


