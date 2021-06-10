//
//  DetailsMovieCordinator.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/10/21.
//

import UIKit

final class DetailsMovieCordinator: Coordinator {
    
    let navigationController: UINavigationController
    let detailsMovieViewController: MovieDetailViewModel
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.detailsMovieViewController = MovieDetailViewModel()
    }
    
    deinit { }
    
    func start(movieContent:PersonContent.MovieContent) {
        let detailsMovieVC = MovieDetailsViewController.instantiate(with: .Main)
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: detailsMovieVC)
        detailsMovieVC.viewModel.data = movieContent
        self.navigationController.present(navBarOnModal, animated: true, completion: nil)
    }
}
