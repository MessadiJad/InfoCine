//
//  MovieDetailViewModel.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/10/21.
//

import Foundation
import RxCocoa
import RxSwift

class MovieDetailViewModel {
    
    let disposeBag = DisposeBag()

    let movieDetailSubject = PublishSubject<PersonContent.MovieContent>()
    var movieData:  BehaviorRelay<[MovieData]>  = BehaviorRelay<[MovieData]>(value: [])
    
    var data = PersonContent.MovieContent()
        
        
    
    func getData() {
        movieDetailSubject.onNext(data)

    }
    
    
    
    
}
