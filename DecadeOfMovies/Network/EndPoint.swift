//
//  API.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import Foundation

private let kFlickAPIKey="547c103df52dfaf5522fd6b1e3b9ead9"

enum EndPoint {
    case images(movieTitle: String, page: Int)

    var path: String {
        switch self {
        case .images(_, _):
            return "https://www.flickr.com/services/rest/"
        }
    }

    var query: String {
        switch self {
        case .images(let movieTitle, let page):
            return "method=flickr.photos.search&api_key=\(kFlickAPIKey)&text=\(movieTitle)&per_page=10&page=\(page)&format=json&nojsoncallback=1"
        }
    }

    var method: String {
        switch self {
        case .images(_, _):
            return "GET"
        }
    }

    var url: URL {
        let fullPath = "\(path)?\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
        return URL(string: fullPath)!
    }

    var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        print("url: \(url)")
        request.httpMethod = method
        return request
    }
}
