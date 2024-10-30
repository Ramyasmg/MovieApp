//
//  Movie.swift
//  MovieApp
//
//  Created by Ramya K on 25/10/24.
//

import Foundation

struct Movie: Codable {
    let Title: String?
    let Year: String?
    let Rated: String?
    let Released: String?
    let Runtime: String?
    let Genre: String?
    let Director: String?
    let Writer: String?
    let Actors: String?
    let Plot: String?
    let Language: String?
    let Country: String?
    let Awards: String?
    let Poster: String?
    let Ratings: [Rating]?
    let Metascore: String?
    let imdbRating: String?
    let imdbVotes: String?
    let imdbID: String?
    let type: String?
    let Dvd: String?
    let BoxOffice: String?
    let Production: String?
    let Website: String?
    let Response: String?
}

struct Rating: Codable {
    let Source: String
    let Value: String
}

struct Section {
    var title: String
    var isOpened: Bool
}
