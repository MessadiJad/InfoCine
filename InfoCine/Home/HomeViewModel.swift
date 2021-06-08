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
    let routes = BehaviorRelay(value: APIRouter.home)

    let disposeBag = DisposeBag()

  
    
    func show(with data: Data) {
        do {
         let decoder = JSONDecoder()
         decoder.keyDecodingStrategy = .convertFromSnakeCase
         let results = try decoder.decode(HomeResult.self, from: data)
            let persons = results.persons
            for person in persons {
                personsBehavior.onNext(person)
            }
        } catch { print("error") }
                
    }
      
    func filterd(_ controller: CategoryViewController, category_id: Int?) {        
        switch category_id {
            case 0:routes.accept(APIRouter.actors)
            case 1:routes.accept(APIRouter.directors)
            case 2:routes.accept(APIRouter.producers)
        default: break
        }
    }
        
}
