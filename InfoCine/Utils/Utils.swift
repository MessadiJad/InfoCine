//
//  Utils.swift
//  CyberMarket
//
//  Created by Jad Messadi on 11/5/20.
//

import UIKit

class Utils {
    
    static let shared = Utils()
    
    func card(with cell : UITableViewCell) {
        let verticalPadding: CGFloat = 8
        let horizentalPadding: CGFloat = 8
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: horizentalPadding/2, dy: verticalPadding/2)
        maskLayer.cornerRadius = 15
        cell.layer.mask = maskLayer
    }
    
    
}
