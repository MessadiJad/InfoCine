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
    func filterd(_ controller: CategoryViewController, category_id: Int?) {
        switch category_id {
        case 0: routesSubject.onNext(.actors)
        case 1: routesSubject.onNext(.directors)
        case 2: routesSubject.onNext(.producers)
        default:
            break
        }
      fetchData()
    }


    let personsBehavior = PublishSubject<Persons>()
    let personBehavior = PublishSubject<PersonContent>()

    let routesSubject = BehaviorSubject<APIRouter>(value: .home)
    let disposeBag = DisposeBag()

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchData), name: Notification.Name("RetryServiceNotificationIdentifier"), object: nil)
    }
    
  
    @objc func fetchData() {
         
        let body = [ "limit" : 2,
                     "offset" : 6] as [String : Int]
    
        routesSubject.subscribe(onNext: { [weak self] route in
                        
            guard let self = self else {return}
            API.shared.service(from: body, router: route) { result in
                switch result {
                case .fail(_):
                    print("fail")
                case .success(let data):
                    print("success")
                    self.show(with: data)
                }
            }
      
        }).disposed(by: disposeBag)

    }
    
    @objc func fetchPerson() {
         
 
        routesSubject.subscribe(onNext: { [weak self] route in
                        
            guard let self = self else {return}
            
            API.shared.detailService(router: route) { (result) in
                switch result {
                case .fail(_):
                    print("fail")
                case .success(let data):
                    print("success")
                    self.showPerson(with: data)
                }
            }
            
        }).disposed(by: disposeBag)

    }

    
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
    
    
    func showPerson(with data: Data) {
        do {
         let decoder = JSONDecoder()
         decoder.keyDecodingStrategy = .convertFromSnakeCase
         let results = try decoder.decode(DetailsPersonResult.self, from: data)
            let details = results.content
                personBehavior.onNext(details)
            
        } catch { print("error") }
    }
    
    
    
    
}

