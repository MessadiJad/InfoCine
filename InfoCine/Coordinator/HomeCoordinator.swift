//
//  ListItemsCoordinator.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import UIKit

final class HomeCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    let homeViewController: HomeViewController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        let viewModel = HomeViewModel()
        self.homeViewController = HomeViewController(viewModel: viewModel)
    }
    
    deinit { }
    
    func start() {
        let homeVC = HomeViewController.instantiate(with: .Main)
        navigationController.show(homeVC, sender: self)
    }
}
