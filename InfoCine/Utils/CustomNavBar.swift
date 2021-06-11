//
//  CustomNavBar.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/9/21.
//

import UIKit

protocol NavBarCustomed:class {
    func setupNavigationBar(with title: String?)
    
}

extension NavBarCustomed where Self: UIViewController {
    
    func setupNavigationBar(with title: String?) {
        
        let appearance = UIBarButtonItem.appearance()
        appearance.setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0.0, vertical: -60), for: .default)
        
        let infoCineColor =  UIColor(red: 148.0/255.0, green: 17.0/255.0, blue: 0/255.0, alpha: 1.0)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor :  infoCineColor]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor :  infoCineColor]
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = infoCineColor
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.largeContentTitle = title
        }else {
            self.title = title
        }
        
    }
}
