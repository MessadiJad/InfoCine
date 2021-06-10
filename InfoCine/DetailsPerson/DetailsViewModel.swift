//
//  DetailsItemViewModel.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import Foundation
import RxSwift
import RxCocoa

class DetailsViewModel {
   
    let personSubject = BehaviorRelay<PersonContent>(value: PersonContent())
    var personSubjectObservable : Observable<PersonContent> {
        return personSubject.asObservable()
    }
      
    let disposeBag = DisposeBag()
    
    func getData(details: DetailsPersonResult) {
        personSubject.accept(details.content)
    }

    func decodeMovies(details: PersonContent) -> Observable<[String:String]> {
        
        var moviesDict = [String:String]()
        if let movieData: [String : PersonContent.Movie] = details.movies {
            for (_, value) in movieData {
                if let filmTitle = value.title, let imageName = value.content?.pictures.first?.content?.name {
                    moviesDict.updateValue(imageName, forKey: filmTitle)
                }
            }
        }

        return Observable.just(moviesDict)
    }
    
    
    func getMovieContent(details: PersonContent) -> Observable<[PersonContent.MovieContent]>{

        if let movieData: [String : PersonContent.Movie] = details.movies {
            var array : [PersonContent.MovieContent] = []
            for (_, value) in movieData {
                if let content = value.content {
                    array.append(content)
                }
            }
            return Observable.just(array)
        }
        
        return Observable.empty()
    }
    
    
    
    
}
    
