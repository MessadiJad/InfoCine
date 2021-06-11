//
//  HomeVC+WebKit.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/11/21.
//

import WebKit

extension HomeViewController {
    
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
    
}
