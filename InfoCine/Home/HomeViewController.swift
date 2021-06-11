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
    
    let viewModel = HomeViewModel(person: [])
    
    @IBOutlet var homeWebView: WKWebView!
    
    let contentController = WKUserContentController()
    let configuration = WKWebViewConfiguration()
    var rubriqueSegmentedControl = UISegmentedControl()
    
    var detailsCoordinator: DetailsCoordinator?
    
    let spinnerView = SpinnerView()
    
    var didChange = false
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(HomeRefresh), name: Notification.Name("RetryServiceNotificationIdentifier"), object: nil)
        loadWebView(route: .home)
        intiSegment()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationBar(with: "Home")
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
