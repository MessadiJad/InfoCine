//
//  ViewController.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import UIKit
import WebKit


class HomeViewController: UIViewController,WKNavigationDelegate,Storyboarded {
  
    
    
    @IBOutlet var homeWebView: WKWebView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let body = [ "limit" : 9,
                     "offset" : 6] as [String : Int]
        
        API.shared.service(from: body, router: .home) { result in
            switch result {
            case .fail(_):
                print("fail")
            case .success(let data):
                print("success")
                self.show(with: data)
                
            }
        }
    }
    
    
    func show(with data: Data) {
        let jsons = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
        if let results = jsons["persons"] as? [[String: AnyObject]] {
            for result in results {
                let content = result["fullname"] as? String
                if (content != nil) {
                    self.receivedContent?.append(content!)
                }
                print(content!)
            }
            self.generatedHtml = self.generateString()
            if ((self.generatedHtml) != nil) {
                self.homeWebView.loadHTMLString((self.generatedHtml!), baseURL: nil)
            }
        }
    }
    
    
    func generateString() -> String? {
        var resultString: String?
        
        let firstString = "<DOCTYPE HTML> \r <html lang=\"en\" \r <head> \r <meta charset = \"utf-8\"> \r </head> \r <body> \r <ul> \r <li>"
        let endString = "</li> \r </ul> \r </body> \r </html>";
        resultString = firstString + self.receivedContent! + endString;
        
        return resultString
    }
    
    
    @IBAction func showCategories(sender: UIBarButtonItem) {
        if let navigationController = self.navigationController {
            categoriesCoordinator = CategoryCoordinator(navigationController: navigationController, categoris: [])
        categoriesCoordinator?.start()
        }
    }
        
    
}


