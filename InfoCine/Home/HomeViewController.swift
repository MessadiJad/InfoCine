//
//  ViewController.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import UIKit
import WebKit


class HomeViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet var homeWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeWebView.navigationDelegate = self

        let url = URL(string: "https://www.lepoint.fr")!
        homeWebView.load(URLRequest(url: url))
        homeWebView.allowsBackForwardNavigationGestures = true
    }


}

