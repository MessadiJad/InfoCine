//
//  MovieDetailsViewController.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/10/21.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailsViewController: UIViewController, Storyboarded, NavBarCustomed {
    
    var viewModel = MovieDetailViewModel()
    
    @IBOutlet weak var movieDetailsTableView: UITableView!
    @IBOutlet weak var movieCover: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(with: viewModel.data.original_title)
        
        self.movieDetailsTableView.tableFooterView = UIView()
        
        var tableData = [MovieData]()
        tableData.append(MovieData.init(title: Strings.description.rawValue, description: viewModel.data.description ?? "-"))
        tableData.append(MovieData.init(title: Strings.production_year.rawValue, description: viewModel.data.production_year ?? "-"))
        tableData.append(MovieData.init(title: Strings.age_limit.rawValue, description: viewModel.data.age_limit ?? "-"))
        tableData.append(MovieData.init(title: Strings.premiere.rawValue, description: viewModel.data.premiere ?? "-"))
        tableData.append(MovieData.init(title: Strings.movie_duration.rawValue, description: viewModel.data.movie_duration ?? "-"))
        tableData.append(MovieData.init(title: Strings.search_engine.rawValue, description: viewModel.data.search_engine ?? "-"))
        tableData.append(MovieData.init(title: Strings.official_website.rawValue, description: viewModel.data.official_website ?? "-"))
        
        self.viewModel.movieData.accept(tableData)
        
        self.viewModel.movieData.asObservable()
            .bind(to: movieDetailsTableView.rx.items(cellIdentifier: String(describing: MovieDetailCell.self), cellType: MovieDetailCell.self)) { row, element, cell in
                cell.configure(tableData: element)
            }
            .disposed(by: viewModel.disposeBag)
        
        if let imageName = viewModel.data.pictures.first?.content?.name {
            movieCover.downloaded(from: .imagesFilm, link: imageName)
        }
        
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
