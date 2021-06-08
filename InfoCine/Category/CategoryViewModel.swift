//
//  CategoryViewModel.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol FilterViewControllerDelegate:class {
    func filterd(_ controller: CategoryViewController, category_id: Int?)
}

class CategoryViewModel {
    
    let categorys = BehaviorRelay<[CategoryModel]>(value: [])
    let listOfCategory = [
        CategoryModel(category_id: 0, title:"Actors"),
        CategoryModel(category_id: 1, title:"Directors"),
        CategoryModel(category_id: 2, title:"Producers")
    ]
    var delegate: FilterViewControllerDelegate?
    let disposeBag = DisposeBag()
    
    init() {
        fetchCategoryList()
    }
    
    func fetchCategoryList() {
        categorys.accept(listOfCategory)
    }
     
    func filter (controller: CategoryViewController, category_id:Int?) {
        delegate = HomeViewModel()
        delegate?.filterd(controller, category_id: category_id)
    }

}
