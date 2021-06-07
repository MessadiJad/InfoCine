//
//  HomeViewModel.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import Foundation
import RxCocoa
import RxSwift

class HomeViewModel: FilterViewControllerDelegate {

    
    let personsBehavior = PublishSubject<Persons>()
    let routes = PublishSubject<APIRouter>()

    let disposeBag = DisposeBag()

    static let selectedCategoryBehavior = BehaviorRelay<CategoryModel>(value: CategoryModel.empty)
   
    func show(with data: Data) {
        do {
         let decoder = JSONDecoder()
         decoder.keyDecodingStrategy = .convertFromSnakeCase
         let results = try decoder.decode(HomeResult.self, from: data)

            let persons = results.persons
            for person in persons {
                personsBehavior.onNext(person)
            }

        } catch {
            print("error")
        }
                
    }
      
    func filterd(_ controller: CategoryViewController, category_id: Int?) {        
        switch category_id {
            case 0:routes.onNext(APIRouter.actors)
            case 1:routes.onNext(APIRouter.directors)
            case 2:routes.onNext(APIRouter.producers)
        default:
            break
        }
    }
    
    
}
