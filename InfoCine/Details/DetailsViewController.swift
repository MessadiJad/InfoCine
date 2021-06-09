//
//  DetailsItemViewController.swift
//  CyberMarket
//
//  Created by Jad Messadi on 10/22/20.
//

import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController, Storyboarded, UICollectionViewDelegateFlowLayout, NavBarCustomed {
    
    var viewModel = DetailsViewModel()
    
    @IBOutlet var personImageView: UIImageView!
    @IBOutlet var lieu_naissanceLbl: UILabel!
    @IBOutlet var professionLbl: UILabel!
    @IBOutlet var urldbpediaLbl: UILabel!
    @IBOutlet var commentaireLbl: UILabel!
    @IBOutlet var nationaliteLbl: UILabel!
    @IBOutlet weak var moviesCollectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.personSubjectObservable.subscribe(onNext: { details in
            if let ActorName = details.nom {
                self.setupNavigationBar(with: ActorName)
            }
            self.urldbpediaLbl.text = details.url_dbpedia
            self.professionLbl.text = details.profession
            self.lieu_naissanceLbl.text = details.lieu_naissance
            self.commentaireLbl.text = details.commentaire
            self.nationaliteLbl.text = details.nationalite
            if let thumbImageUrl = details.photo {
                self.setupImageItem(imageUrl: thumbImageUrl)
            }
        }).disposed(by: viewModel.disposeBag)
        
        
        let items = Observable.just(
            (0..<5).map{ "Test \($0)" }
        )
        
        items.asObservable().bind(to: self.moviesCollectionView.rx.items(cellIdentifier: "MovieCollectionCell", cellType: MovieCollectionCell.self)) { row, data, cell in
            cell.movieTitle.text = data
        }.disposed(by: viewModel.disposeBag)

        moviesCollectionView.rx.setDelegate(self).disposed(by: viewModel.disposeBag)
    

}
    
    func setupImageItem(imageUrl: String) {
        personImageView.contentMode = .scaleToFill
        personImageView.clipsToBounds = true
        personImageView.downloaded(from: imageUrl)
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let width = collectionView.bounds.width
         let cellWidth = (width - 30) / 3
         return CGSize(width: cellWidth, height: cellWidth / 0.6)
     }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader{
            sectionHeader.sectionHeaderlabel.text = "Films"
            return sectionHeader
        }
        return UICollectionReusableView()
    }
}
