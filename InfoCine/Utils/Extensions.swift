//
//  Extensions.swift
//  CyberMarket
//
//  Created by Jad Messadi on 10/21/20.
//

import UIKit
import WebKit

extension UIView {
    
    func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        
        if #available(iOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
        }
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
}


extension UIButton {
    func create(_ title : String, titleColor: UIColor, backgroundColor : UIColor){
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleToFill) {
        if let fullUrl = Environment.ImagesURL(type: .imagesPerson, id: link) {
            downloaded(from: fullUrl, contentMode: mode)
        }
    }
}

extension WKWebView {
    func injectJS(resource: String, type: String, forMainFrameOnly: Bool = true) {
            if let filepath = Bundle.main.path(forResource: resource, ofType: type) {
                if let str = try? String(contentsOfFile: filepath) {
                    injectJS(string: str, forMainFrameOnly: forMainFrameOnly)
                }
            }
        }

    func injectJS(string: String, forMainFrameOnly: Bool = true) {
            let script = WKUserScript(source: string, injectionTime: .atDocumentStart, forMainFrameOnly: forMainFrameOnly)
            configuration.userContentController.addUserScript(script)
        }

    
    func injectCSS(string: String, suffixIdentifier: String, forMainFrameOnly: Bool = true) {
            let identifier = "InfoCine-added-CSS-\(suffixIdentifier)"
            let cssInjection = """
            var d = document.createElement('style');
            d.setAttribute('type', 'text/css');
            d.setAttribute('id', '\(identifier)');
            d.innerHTML = `
            \(string)
            `
            document.firstElementChild.appendChild(d);
            """
            let script = WKUserScript(source: cssInjection, injectionTime: .atDocumentStart, forMainFrameOnly: forMainFrameOnly)
            configuration.userContentController.addUserScript(script)
        }
    
}
