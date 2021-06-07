//
//  AppCoordinator.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//


import UIKit

class Coordinator { }

final class AppCoordinator {
    
    fileprivate let navigationController: UINavigationController
    fileprivate var childCoordinators = [Coordinator]()
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {  }
    
    func start() {
        
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        
        homeCoordinator.start()
        childCoordinators.append(homeCoordinator)
    }
    
}
