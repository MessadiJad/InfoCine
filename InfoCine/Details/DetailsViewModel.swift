//
//  DetailsItemViewModel.swift
//  CyberMarket
//
//  Created by Jad Messadi on 10/22/20.
//

import Foundation
import RxSwift
import RxCocoa

class DetailsViewModel {
   
    let personSubject = BehaviorRelay<PersonContent>(value: PersonContent.empty)
    var personSubjectObservable : Observable<PersonContent> {
        return personSubject.asObservable()
    }
      
    let disposeBag = DisposeBag()
    
    func getData(person: PersonContent) {
       personSubject.accept(person)
    }

}
    
