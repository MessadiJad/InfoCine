//
//  DetailsItemViewController.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController, Storyboarded, UICollectionViewDelegateFlowLayout {
    
    var viewModel = DetailsViewModel()
    
    @IBOutlet var personImageView: UIImageView!
    @IBOutlet var lieu_naissanceLbl: UILabel!
    @IBOutlet var professionLbl: UILabel!
    @IBOutlet var urldbpediaLbl: UILabel!
    @IBOutlet var commentaireLbl: UILabel!
    @IBOutlet var nationaliteLbl: UILabel!
    @IBOutlet weak var moviesCollectionView: UICollectionView!

    var movieDetailsCoordinator: DetailsMovieCordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewModel.personSubject.subscribe(onNext: { details in
           
            self.commentaireLbl.text = details.commentaire
            if let namePerson = details.nom {
                self.title = namePerson
            }
            self.professionLbl.text = details.profession  ?? "-"
            self.lieu_naissanceLbl.text = details.lieu_naissance  ?? "-"
            self.nationaliteLbl.text = details.nationalite  ?? "-"
            if let thumbImageUrl = details.photo {
                self.setupImageItem(imageUrl: thumbImageUrl)
            }
         
            self.viewModel.decodeMovies(details: details).bind(to: self.moviesCollectionView.rx.items(cellIdentifier: "MovieCollectionCell", cellType: MovieCollectionCell.self)) { row, data, cell in
                cell.movieTitle.text = data.key
                cell.movieCover.downloaded(from: .imagesFilm, link: data.value)
                cell.shadowDecorate()
             }.disposed(by: self.viewModel.disposeBag)
             
            self.moviesCollectionView
                .rx
                .itemSelected
                    .subscribe(onNext:{ indexPath in
                        
                        self.viewModel.getMovieContent(details: details).subscribe(onNext: { data in
                            self.openMovieDetailsScreen(data: data[indexPath.row])
                        }).disposed(by: self.viewModel.disposeBag)
                        
                        
                    }).disposed(by: self.viewModel.disposeBag)
           
        }).disposed(by: self.viewModel.disposeBag)
        
        moviesCollectionView.rx.setDelegate(self).disposed(by: viewModel.disposeBag)

}
    
    func setupImageItem(imageUrl: String) {
        personImageView.contentMode = .scaleToFill
        personImageView.clipsToBounds = false
        personImageView.downloaded(from: .imagesPerson, link: imageUrl)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
      {
         return CGSize(width: 100.0, height: 150.0)
      }
    
    func openMovieDetailsScreen(data : PersonContent.MovieContent) {
        if let navigationController = self.navigationController {
        self.movieDetailsCoordinator = DetailsMovieCordinator(navigationController: navigationController)
        self.movieDetailsCoordinator?.start(movieContent: data)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = "Home"
    }
    
}
