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

class PersonContent: Decodable {
    
    var nom: String?
    var url_dbpedia: String?
    var lieu_naissance: String?
    var nationalite: String?
    var commentaire: String?
    var profession: String?
    var date_naissance: String?
    var photo: String?
    
    
    init(nom: String, url_dbpedia: String, lieu_naissance: String, nationalite: String, commentaire: String, profession: String, date_naissance: String, photo: String) {
        self.nom = nom
        self.url_dbpedia = url_dbpedia
        self.lieu_naissance = lieu_naissance
        self.nationalite = nationalite
        self.commentaire = commentaire
        self.profession = profession
        self.date_naissance = date_naissance
        self.photo = photo
  
}

    enum CodingKeys: String, CodingKey   {
        case nom
        case url_dbpedia
        case lieu_naissance
        case nationalite
        case commentaire
        case profession
        case date_naissance
        case photo

   }

}

extension PersonContent {
    static var empty: PersonContent {
        return PersonContent(nom: "", url_dbpedia: "", lieu_naissance: "", nationalite: "", commentaire: "", profession: "", date_naissance: "", photo: "")
    }
}
