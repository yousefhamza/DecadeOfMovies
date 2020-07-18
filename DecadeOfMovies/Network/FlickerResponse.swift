//
//  FlickerResponse.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import Foundation

class FlickerResponse: Codable {
    let photos: [FlickerPhoto]
    let pageSize: Int
    let page: Int
    let totalPages: Int

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let photosDictionary = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .photosDictionary)
        photos = try photosDictionary.decode([FlickerPhoto].self, forKey: .photos)
        pageSize = try photosDictionary.decode(Int.self, forKey: .pageSize)
        page = try photosDictionary.decode(Int.self, forKey: .page)
        totalPages = try photosDictionary.decode(Int.self, forKey: .totalPages)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var response = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .photosDictionary)
        try response.encode(photos, forKey: .photos)
    }

    enum CodingKeys: String, CodingKey {
        case photosDictionary = "photos"
        case photos = "photo"
        case pageSize = "perpage"
        case page = "page"
        case totalPages = "pages"
    }
}

class FlickerPhoto: Codable {
    let farm: Int
    let server: String
    let id: String
    let secret: String
}
