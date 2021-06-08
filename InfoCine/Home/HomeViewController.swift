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

class HomeViewController: BaseViewController,WKNavigationDelegate,WKUIDelegate,Storyboarded, WKScriptMessageHandler {
    
    
    
    @IBOutlet var homeWebView: WKWebView!
    let contentController = WKUserContentController()
    let configuration = WKWebViewConfiguration()
    
    var generatedHtml : String?
    var receivedContent: String? = ""
    private let viewModel = HomeViewModel()
    var categoryCoordinator: CategoryCoordinator?
    var detailsCoordinator: DetailsCoordinator?
    var detailsViewController: DetailsViewModel?

    
    let spinnerView = SpinnerView()

    let disposeBag = DisposeBag()

 
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        viewModel.fetchData()
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        spinnerView.show(uiView: self.view)

       self.homeWebView.evaluateJavaScript("clearTable();")

        self.homeWebView.reload()

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
        self.homeWebView.evaluateJavaScript("createTable();")
        viewModel.personsBehavior.subscribe{ element in
            let value = element.map{ return $0 }
            if let imageUrl = value.element?.img, let fullname = value.element?.fullname, let desc = value.element?.commentaire{
                if value.element != nil {
                    self.spinnerView.hide()
                    self.homeWebView.evaluateJavaScript("fillTable([['\(imageUrl)','\(fullname)','\(desc)']]);")
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
            print(message.body)
            if let navigationController = self.navigationController {
               
                viewModel.fetchPerson()
                
                viewModel.personBehavior.subscribe({ person in
                    self.detailsCoordinator = DetailsCoordinator(navigationController: navigationController)
                    if let personC = person.element {
                        self.detailsCoordinator?.start(person :personC )

                    }
                    
                }).disposed(by: viewModel.disposeBag)
            
                    }
                 


            }
        }
    

    @IBAction func showCategories(sender: UIBarButtonItem) {
        if let navigationController = self.navigationController {
            categoryCoordinator = CategoryCoordinator(navigationController: navigationController, categoris: [])
      //      categoryCoordinator?.categoryViewController.viewModel.delegate =  self.viewModel
            categoryCoordinator?.start()
        }
    }
    
}


