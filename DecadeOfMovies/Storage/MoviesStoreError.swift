//
//  MoviesStoreError.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import Foundation

enum MoviesStoreError: Equatable, Error {
    case moviesJSONNotFound
    case alreadyImported
    case importingDecodingError(error: Error)
    case saveError(error: Error)

    static func == (lhs: MoviesStoreError, rhs: MoviesStoreError) -> Bool {
        switch (lhs, rhs) {
        case (.moviesJSONNotFound, .moviesJSONNotFound),
             (.alreadyImported, .alreadyImported),
             (.importingDecodingError, .importingDecodingError),
             (.saveError, .saveError):
            return true
        default:
            return false
        }
    }
}
