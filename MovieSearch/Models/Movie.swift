//
//  Movie.swift
//  MovieSearch
//
//  Created by Emily Asch on 2/24/22.
//

import Foundation

struct Movies: Decodable{
    var results: [Movie]
}

struct Movie: Decodable{
    let title: String
    let description: String
    let rating: Double
    let image: String?
    enum CodingKeys: String, CodingKey{
        case title = "original_title"
        case description = "overview"
        case rating = "popularity"
        case image = "poster_path"
    }
    
}


