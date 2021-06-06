//
//  FilterCoordinator.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import UIKit

final class CategoryCoordinator: Coordinator {

    fileprivate let navigationController: UINavigationController
    let categoryViewController: CategoryViewController

    init(navigationController: UINavigationController,categoris: [CategoryModel]) {
        self.navigationController = navigationController
        self.categoryViewController = CategoryViewController()
    }

    deinit { }

    func start() {
        
        let categoryVC = CategoryViewController.instantiate(with: .Category)
        self.navigationController.present(categoryVC, animated: true, completion: nil)
    }

}

