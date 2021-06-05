//
//  CategoryModel.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import Foundation

class CategoryModel {
    
    var id: Int?
    var title: String?
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}


extension CategoryModel {
    static var empty: CategoryModel {
        return CategoryModel(id:0, title:"")
    }
}
