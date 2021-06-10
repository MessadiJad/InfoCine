//
//  MovieDetailsModel.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/10/21.
//

import Foundation

struct MovieData {
    var title: String?
    var description: String?
}

public enum Strings:String {
    case description             = "Description"
    case production_year         = "Production year"
    case age_limit               = "Age limit"
    case premiere                = "Premiere"
    case movie_duration        = "Movie duration"
    case search_engine        = "Search engine"
    case official_website     = "Official website"
}
