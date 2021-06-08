//
//  Persons.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import Foundation



struct HomeResult: Decodable {
    let path : String
    let persons : [Persons]
    let limit : String
    let offset: Int
}

class Persons: Decodable {
    
    var id: Int?
    var idPerson: Int?
    var fullname: String?
    var urldbpedia: String?
    var date_naissance: String?
    var commentaire: String?
    var code: String?
    var lastname: String?
    var path :String?
    var img: String?
    
    init(id: Int, idPerson: Int, fullname: String, urldbpedia: String, date_naissance: String, commentaire: String, code: String, lastname: String, path: String, img: String) {
        self.id = id
        self.idPerson = idPerson
        self.fullname = fullname
        self.urldbpedia = urldbpedia
        self.date_naissance = date_naissance
        self.commentaire = commentaire
        self.code = code
        self.lastname = lastname
        self.path = path
        self.img = img
        
    }
    
    enum CodingKeys: String, CodingKey   {
        case id
        case idPerson
        case fullname
        case urldbpedia
        case date_naissance
        case commentaire
        case code
        case lastname
        case path
        case img

    }
}

extension HomeResult {
    static var empty: HomeResult {
        return HomeResult(path: "", persons: [], limit:"", offset: 0)
    }
}
