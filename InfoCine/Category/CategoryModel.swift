//
//  CategoryModel.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import Foundation

class CategoryModel {
    
    var category_id: Int?
    var title: String?
    
    init(category_id: Int, title: String) {
        self.category_id = category_id
        self.title = title
    }
}

extension CategoryModel {
    static var empty: CategoryModel {
        return CategoryModel(category_id:0, title:"")
    }
}
