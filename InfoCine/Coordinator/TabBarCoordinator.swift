//
//  TabBarCoordinator.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/6/21.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    let tabBarViewController: TabBarViewController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarViewController = TabBarViewController()
    }
    
    deinit { }
    
    func start() {
        let tabBarVC = TabBarViewController.instantiate(with: .Main)
        navigationController.show(tabBarVC, sender: self)
    }
}
