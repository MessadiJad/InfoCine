//
//  DetailsPerson.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/8/21.
//

import Foundation


struct DetailsPersonResult: Decodable {
    let id : String
    let idPerson : String
    let content : PersonContent
    let title : String
    let type : String
    let suppression : Int
}

struct PersonContent: Decodable {
    
    var nom: String?
    var url_dbpedia: String?
    var lieu_naissance: String?
    var nationalite: String?
    var commentaire: String?
    var profession: String?
    var date_naissance: Int?
    var photo: String?
    var movies: [String:Movie]?
        
    class Movie : Decodable{
        var title : String?
        var content : MovieContent?
    }
 
    class MovieContent : Decodable {
        var brightcove_id : String? = nil
        var product_title : String? = nil
        var age_limit : String? = nil
        var description : String? = nil
        var movie_duration : String? = nil
        var imdb_id : String? = nil
        var original_title : String? = nil
        var premiere : String? = nil
        var production_year : String? = nil
        var search_engine : String? = nil
        var official_website : String? = nil
        var pictures : [PictureContent] = []
    }
    
    class PictureContent : Decodable{
        var title : String?
        var content : PictureDetails?

    }
  
    class PictureDetails : Decodable{
            var name : String?
            var url : String?
            var width : String?
            var height : String?
            var mime_type : String?
            var picture_type : String?

       }
    
}

