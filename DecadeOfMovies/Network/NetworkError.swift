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

    var description: String {
        switch self {
        case .clientError:
            return "Request failed, but it's my fault"
        case .serverError:
            return "Request failed, but it's the server fault"
        case .noServerResponse:
            return "Server didn't return any response"
        case .couldNotDecodeResponse:
            return "Server returned unexpected response"
        }
    }
}
