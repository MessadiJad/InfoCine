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

    var detailsCoordinator: DetailsCoordinator?

    let spinnerView = SpinnerView()

    let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        self.setupNavigationBar(with: "Home")
  
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
        intiSegment()
   
    }
     
    
    func intiSegment() {
        let segment: UISegmentedControl = UISegmentedControl(items: ["Actors", "Directors", "Producers",])
           segment.sizeToFit()
           if #available(iOS 13.0, *) {
               segment.selectedSegmentTintColor = .init(hex: "#B7312C")
           } else {
              segment.tintColor = .init(hex: "#B7312C")
           }
            segment.selectedSegmentIndex = 0
        segment.layer.borderColor = UIColor.init(hex: "#B7312C").cgColor
            segment.layer.borderWidth = 1
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.darkGray], for: .normal)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        segment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segment.selectedSegmentIndex = UISegmentedControl.noSegment

           self.navigationItem.titleView = segment
    }
    
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.viewModel.filter(controller: self, category_id: sender.selectedSegmentIndex)
        homeWebView.reload()
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
            viewModel.routesSubject.onNext(.personDetails)
            if let navigationController = self.navigationController {
                if let str = message.body as? String {
                        viewModel.fetchDetailsPerson(idPeron: str, completion: { (result) in
                        self.detailsCoordinator = DetailsCoordinator(navigationController: navigationController)
                        self.detailsCoordinator?.start(details: result)
                    })
                }
            }
            }
        }
    
    @IBAction func HomeRefresh(sender: UIBarButtonItem) {
            //Home refresh
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = " "
    }
}


