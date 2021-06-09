//
//  HomeViewModel.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import Foundation
import RxCocoa
import RxSwift

class HomeViewModel: CategoryDelegate {
 
    let personsBehavior = PublishSubject<Persons>()
    let routesSubject = BehaviorSubject<APIRouter>(value: .home)
    
    let disposeBag = DisposeBag()

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchPersons), name: Notification.Name("RetryServiceNotificationIdentifier"), object: nil)
    }
    
    @objc func fetchPersons() {
         
        let body = [ "limit" : 10,
                     "offset" : 5] as [String : Int]
    
        routesSubject.take(1).subscribe(onNext: { [weak self] route in
                        
            guard let self = self else {return}
            API.shared.service(from: body, router: route) { result in
                switch result {
                case .fail:
                showErrorAlertView(title: NSLocalizedString("ERROR_TITLE", comment: ""), body: NSLocalizedString("ERROR_BODY_ITEMS", comment: ""))
                case .success(let data):
                    self.decodePersons(with: data)
                }
            }
      
        }).disposed(by: disposeBag)

    }
    
    func fetchDetailsPerson(idPeron: String, completion: @escaping (PersonContent) -> Void){
        
        routesSubject.take(1).subscribe{ route in
            API.shared.detailService(router: route, idPeron: idPeron) { (result) in
                switch result {
                case .fail:
                showErrorAlertView(title: NSLocalizedString("ERROR_TITLE", comment: ""), body: NSLocalizedString("ERROR_BODY_ITEMS", comment: ""))
                case .success(let data):
                    guard let res = self.decodeDetailsPerson(with: data) else { return }
                    completion(res)
                }
            }
        }.disposed(by: disposeBag)
        
    }
    
    private func decodePersons(with data: Data) {
        
        do {
         let decoder = JSONDecoder()
         decoder.keyDecodingStrategy = .convertFromSnakeCase
         let results = try decoder.decode(HomeResult.self, from: data)
            let persons = results.persons
            for person in persons {
                personsBehavior.onNext(person)
            }
        } catch {
            showErrorAlertView(title: NSLocalizedString("ERROR_TITLE", comment: ""), body: NSLocalizedString("ERROR_BODY_ITEMS", comment: ""))
        }
        
    }
    
   private func decodeDetailsPerson(with data: Data) -> PersonContent? {
        do {
         let decoder = JSONDecoder()
         decoder.keyDecodingStrategy = .convertFromSnakeCase
         let results = try decoder.decode(DetailsPersonResult.self, from: data)
            return results.content
        } catch {
            showErrorAlertView(title: NSLocalizedString("ERROR_TITLE", comment: ""), body: NSLocalizedString("ERROR_BODY_ITEMS", comment: ""))
        }
        return nil
    }
     
    func categorySelected(_ controller: CategoryViewController, category_id: Int?) {
        switch category_id {
            case 0: routesSubject.onNext(.actors)
            case 1: routesSubject.onNext(.directors)
            case 2: routesSubject.onNext(.producers)
        default: break
        }
      fetchPersons()
    }
    
}

