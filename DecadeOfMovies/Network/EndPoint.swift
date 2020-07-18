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
    case flickPhoto(photo: FlickerPhoto)

    var path: String {
        switch self {
        case .images(_, _):
            return "https://www.flickr.com/services/rest/"
        case .flickPhoto(let photo):
            return "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
        }
    }

    var query: String? {
        switch self {
        case .images(let movieTitle, let page):
            return "method=flickr.photos.search&api_key=\(kFlickAPIKey)&text=\(movieTitle)&per_page=10&page=\(page)&format=json&nojsoncallback=1"
        default:
            return nil
        }
    }

    var method: String {
        switch self {
        case .images(_, _), .flickPhoto(_):
            return "GET"
        }
    }

    var url: URL {
        var fullPath = path
        if let query = self.query {
            fullPath += "?\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
        }
        print("url: \(fullPath)")
        return URL(string: fullPath)!
    }

    var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        return request
    }
}
