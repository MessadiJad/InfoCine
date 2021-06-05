//
//  CategoryViewModel.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import Foundation
import RxCocoa
import RxSwift

class CategoryViewModel {
    
    let categorys = BehaviorRelay<[CategoryModel]>(value: [])
    
    static let selectedCategoryBehavior = BehaviorRelay<CategoryModel>(value: CategoryModel.empty)
    var selectedCategoryObservable : Observable<CategoryModel> {
        return CategoryViewModel.selectedCategoryBehavior.asObservable()
    }
    
    let disposeBag = DisposeBag()
    
    func fetchCategoryList() {
        let listOfCategory = [
            CategoryModel(id: 0, title:"Actors"),
            CategoryModel(id: 1, title:"Directors"),
            CategoryModel(id: 2, title:"Producers")
        ]
        categorys.accept(listOfCategory)
    }
    
    func selectCategory(with choice : CategoryModel) {
        CategoryViewModel.selectedCategoryBehavior.accept(choice)
    }
}
