//
//  DetailsItemCoordinator.swift
//  CyberMarket
//
//  Created by Jad Messadi on 10/22/20.
//

import UIKit

final class DetailsCoordinator: Coordinator {

    fileprivate let navigationController: UINavigationController
    fileprivate let detailsViewController: DetailsViewController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.detailsViewController = DetailsViewController()
    }

    deinit {
    }

    func start(details: DetailsPersonResult) {
        let detailsVC = DetailsViewController.instantiate(with: .Main)
        detailsVC.viewModel.getData(details: details)
        navigationController.show(detailsVC, sender: details)
    }

}

