//
//  MovieDetailCell.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/10/21.
//

import UIKit

class MovieDetailCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    func configure(tableData: MovieData) {
        self.lblTitle.text = tableData.title ?? ""
        self.lblDescription.text = tableData.description ?? ""
    }
    
}
