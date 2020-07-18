//
//  Movie.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import Foundation

class MoviesJSON: Codable {
    let movies: [Movie]
}

class Movie: Codable {
    let title: String
    let year: Int
    let genres: [String]
    let cast: [String]
}
