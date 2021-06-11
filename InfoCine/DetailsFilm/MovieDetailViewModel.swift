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
    
    var data = PersonContent.MovieContent()

    var movieData:  BehaviorRelay<[MovieData]>  = BehaviorRelay<[MovieData]>(value: [])
    
    let disposeBag = DisposeBag()

}
