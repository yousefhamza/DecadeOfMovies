//
//  URLRequestCreatorMock.swift
//  DecadeOfMoviesTests
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import Foundation

class URLRequestCreatorMock: URLRequestCreator {
    let urlPath: String
    init(urlPath: String) {
        self.urlPath = urlPath
    }

    var url: URL { URL(string: urlPath)! }

    var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}

class HTTPPinResponse: Codable {
    let url: String
}
