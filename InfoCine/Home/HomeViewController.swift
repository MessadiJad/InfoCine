//
//  ViewController.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController,WKNavigationDelegate,WKUIDelegate,Storyboarded, WKScriptMessageHandler, NavBarCustomed {
   
    private let viewModel = HomeViewModel()
    
    @IBOutlet var homeWebView: WKWebView!
    let contentController = WKUserContentController()
    let configuration = WKWebViewConfiguration()

    var categoryCoordinator: CategoryCoordinator?
    var detailsCoordinator: DetailsCoordinator?

    let spinnerView = SpinnerView()

    let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(with: "Home")
        homeWebView.navigationDelegate = self
        homeWebView.uiDelegate = self
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        configuration.preferences = preferences
        configuration.userContentController = contentController
      
        let url = Bundle.main.url(forResource: "ListView", withExtension: "html")!
        homeWebView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        homeWebView.load(request)
        
        viewModel.fetchPersons()
   
    }
     
    override func viewDidAppear(_ animated: Bool) {
       // spinnerView.show(uiView: self.view)
  
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
        self.homeWebView.evaluateJavaScript("clearTable();")
        self.homeWebView.evaluateJavaScript("createTable();")
        viewModel.personsBehavior.subscribe{ element in
            let value = element.map{ return $0 }
            if let id = value.element?.id, let imageId = value.element?.img, let fullname = value.element?.fullname, let desc = value.element?.commentaire{
                if value.element != nil {
                    self.spinnerView.hide()
                    guard let imageUrl = Environment.ImagesURL(type: .imagesPerson, id: imageId) else {return}
                    self.homeWebView.evaluateJavaScript("fillTable([['\(id)','\(imageUrl)','\(fullname)','\(desc)']]);")
                }
            }
        }.disposed(by: viewModel.disposeBag)
        userControllerList(webView)
    }
    
    func userControllerList(_ webView : WKWebView) {
            let userController = webView.configuration.userContentController
            userController.removeScriptMessageHandler(forName: "openDetails")
            userController.add(self, name: "openDetails")
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "openDetails" {
            viewModel.routesSubject.onNext(.person)
            if let navigationController = self.navigationController {
                if let str = message.body as? String {
                        viewModel.fetchDetailsPerson(idPeron: str, completion: { (result) in
                        self.detailsCoordinator = DetailsCoordinator(navigationController: navigationController)
                        self.detailsCoordinator?.start(person :result)
                    })
                }
            }
            }
        }
    
    @IBAction func showCategories(sender: UIBarButtonItem) {
        if let navigationController = self.navigationController {
            categoryCoordinator = CategoryCoordinator(navigationController: navigationController, categoris: [])
            categoryCoordinator?.start()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = " "
    }
}


