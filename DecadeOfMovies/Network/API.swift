//
//  API.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import Foundation

enum EndPoint {
    case images(movieTitle: String)

    var url: String {
        switch self {
        case .images(let movieTitle):
            return "http​s:​//api.flickr.​com​/services/rest/?method=flickr.photos.​search​&api_key={ YOUR_API_KEY}&format=json&nojsoncallback=​1​&text=\(movieTitle)&page=​1​&per_pa ge=​10"
        }
    }

    var method: String {
        switch self {
        case .images(_):
            return "GET"
        }
    }

    var urlRequest: URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        return request
    }
}
