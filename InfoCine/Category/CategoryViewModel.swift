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
     var delegate: FilterViewControllerDelegate?

    
    func filter (controller: CategoryViewController, category_id:Int?) {
        delegate = HomeViewModel()
        delegate?.filterd(controller, category_id: category_id)
    }

    let categorys = BehaviorRelay<[CategoryModel]>(value: [])
    
    static let selectedCategoryBehavior = BehaviorRelay<CategoryModel>(value: CategoryModel.empty)
    var selectedCategoryObservable : Observable<CategoryModel> {
        return CategoryViewModel.selectedCategoryBehavior.asObservable()
    }
    
    let listOfCategory = [
        CategoryModel(category_id: 0, title:"Actors"),
        CategoryModel(category_id: 1, title:"Directors"),
        CategoryModel(category_id: 2, title:"Producers")
    ]
    let disposeBag = DisposeBag()
    
    init() {
        fetchCategoryList()
    }
    
    func fetchCategoryList() {
        
        categorys.accept(listOfCategory)
    }
    
    func selectCategory(with choice : CategoryModel) {
        CategoryViewModel.selectedCategoryBehavior.accept(choice)
    }
}
