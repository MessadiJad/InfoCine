//
//  Storyboarded.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/6/21.
//

import UIKit

enum Storyboard : String  {
    case Main
}

protocol Storyboarded {
    static func instantiate(with name: Storyboard) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(with name: Storyboard) -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: name.rawValue, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
