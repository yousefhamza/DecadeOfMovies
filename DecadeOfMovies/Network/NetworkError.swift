//
//  NetworkError.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import Foundation

enum NetworkError: Error, Equatable {
    case clientError
    case serverError
    case noServerResponse
    case couldNotDecodeResponse
}
