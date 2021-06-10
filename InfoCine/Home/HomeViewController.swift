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
   
    private let viewModel = HomeViewModel(person: [])
    
    @IBOutlet var homeWebView: WKWebView!
    let contentController = WKUserContentController()
    let configuration = WKWebViewConfiguration()
    var rubriqueSegmentedControl = UISegmentedControl()
    
    var detailsCoordinator: DetailsCoordinator?

    let spinnerView = SpinnerView()

    let disposeBag = DisposeBag()
    var didChange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(HomeRefresh), name: Notification.Name("RetryServiceNotificationIdentifier"), object: nil)
        loadWebView(route: .home)
        intiSegment()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Home"
    }
    
    func loadWebView(route: APIRouter) {
        spinnerView.show(uiView: self.view)
        viewModel.fetchPersons(route: route) { stat in
            if stat { self.homeWebView.reload() }
        }
        
    }
    
    func intiSegment() {
        rubriqueSegmentedControl = UISegmentedControl(items: ["Actors", "Directors", "Producers",])
        rubriqueSegmentedControl.sizeToFit()
           if #available(iOS 13.0, *) {
            rubriqueSegmentedControl.selectedSegmentTintColor = .init(hex: "#B7312C")
           } else {
            rubriqueSegmentedControl.tintColor = .init(hex: "#B7312C")
           }
        rubriqueSegmentedControl.selectedSegmentIndex = 0
        rubriqueSegmentedControl.layer.borderColor = UIColor.init(hex: "#B7312C").cgColor
        rubriqueSegmentedControl.layer.borderWidth = 1
        rubriqueSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.darkGray], for: .normal)
        rubriqueSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        rubriqueSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        rubriqueSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment

           self.navigationItem.titleView = rubriqueSegmentedControl
    }
    
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0 : loadWebView(route: .actors)
            case 1 : loadWebView(route: .directors)
            case 2 : loadWebView(route: .producers)
        default: break
        }
    }
    
  
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showErrorAlertView(title: NSLocalizedString("ERROR_TITLE", comment: ""), body: NSLocalizedString("ERROR_BODY_ITEMS", comment: ""))

    }
 
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        homeWebView.injectJS(resource: "Script-functions", type: "js")
        if let filepath = Bundle.main.path(forResource: "Style", ofType: "css") {
            if let str = try? String(contentsOfFile: filepath) {
                webView.injectCSS(string: str, suffixIdentifier: "Style")
            }
        }
        didChange = true

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.homeWebView.evaluateJavaScript("clearTable();")
        self.homeWebView.evaluateJavaScript("createTable();")
        for element in viewModel.personsArray {
            if let id = element.id, let imageId = element.img, let fullname = element.fullname, let desc = element.commentaire{
                    self.spinnerView.hide()
                    guard let imageUrl = Environment.ImagesURL(type: .imagesPerson, id: imageId) else {return}
                    self.homeWebView.evaluateJavaScript("fillTable([['\(id)','\(imageUrl)','\(fullname)','\(desc)']]);")
            }
        }
       
        userControllerList(webView)
    }
    
    func userControllerList(_ webView : WKWebView) {
            let userController = webView.configuration.userContentController
            userController.removeScriptMessageHandler(forName: "openDetails")
            userController.add(self, name: "openDetails")
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "openDetails" {
            viewModel.detailsRouteSubject.onNext(.personDetails)
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

        loadWebView(route: .home)
        rubriqueSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = " "
        didChange = false

    }
    
    override func viewLayoutMarginsDidChange() {
         if didChange {
            self.navigationController!.navigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 96.0)
             didChange.toggle()
             }
         }
}


