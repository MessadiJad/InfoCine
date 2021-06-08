//
//  DetailsItemViewController.swift
//  CyberMarket
//
//  Created by Jad Messadi on 10/22/20.
//

import UIKit

class DetailsViewController: UIViewController, Storyboarded {
    
    var viewModel = DetailsViewModel()
    var scrollView = UIScrollView()
    let itemImageView = UIImageView()
    let itemNameLabel = UILabel()
    let itemDateLabel = UILabel()
    let itemDescriptionLabel = UILabel()
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"

    }

   

}
