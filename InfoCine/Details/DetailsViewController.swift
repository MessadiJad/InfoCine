//
//  DetailsItemViewController.swift
//  CyberMarket
//
//  Created by Jad Messadi on 10/22/20.
//

import UIKit

class DetailsViewController: UIViewController, Storyboarded {
    
    var viewModel = DetailsViewModel()

  
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.personSubjectObservable.subscribe(onNext: { details in
            self.title = details.nom
        }).disposed(by: viewModel.disposeBag)

   

}

}
