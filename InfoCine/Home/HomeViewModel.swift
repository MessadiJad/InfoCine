//
//  HomeViewModel.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import Foundation
import RxCocoa
import RxSwift



class HomeViewModel {
 
    let detailsRouteSubject = BehaviorSubject<APIRouter>(value: .personDetails)
    var personsArray : [Persons]
    let disposeBag = DisposeBag()

    init(person : [Persons]) {
        self.personsArray = person
    }
    
    func fetchPersons(route : APIRouter, completion: @escaping (Bool)-> Void) {
         
        let body = [ "limit" : 10,
                     "offset" : 6] as [String : Int]
    
            API.shared.service(from: body, router: route) { result in
                switch result {
                case .fail:
                showErrorAlertView(title: NSLocalizedString("ERROR_TITLE", comment: ""), body: NSLocalizedString("ERROR_BODY_ITEMS", comment: ""))
                case .success(let data):
                    self.decodePersons(with: data) { stat in
                        completion(stat)
                    }
                }
            }
      
    }
    
    func fetchDetailsPerson(idPeron: String, completion: @escaping (DetailsPersonResult) -> Void){
        
        detailsRouteSubject.take(1).subscribe{ route in
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
    
    private func decodePersons(with data: Data, completion: @escaping (Bool) -> Void) {
        do {
         let decoder = JSONDecoder()
         decoder.keyDecodingStrategy = .convertFromSnakeCase
         let results = try decoder.decode(HomeResult.self, from: data)
            personsArray.removeAll()
            for person in results.persons {
                personsArray.append(person)
            }
           completion(true)
        } catch {
            showErrorAlertView(title: NSLocalizedString("ERROR_TITLE", comment: ""), body: NSLocalizedString("ERROR_BODY_ITEMS", comment: ""))
            completion(false)

        }
        
    }
    
 
    
   private func decodeDetailsPerson(with data: Data) -> DetailsPersonResult? {
        do {
         let decoder = JSONDecoder()
         decoder.keyDecodingStrategy = .convertFromSnakeCase
         let results = try decoder.decode(DetailsPersonResult.self, from: data)
            return results
        } catch {
            showErrorAlertView(title: NSLocalizedString("ERROR_TITLE", comment: ""), body: NSLocalizedString("ERROR_BODY_ITEMS", comment: ""))
        }
        return nil
    }
     
}

