//
//  MovieMO+SortDescriptor.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import Foundation
import CoreData

extension MovieMO {
    static var normalSortDescriptor: [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: "year", ascending: true),
            NSSortDescriptor(key: "title", ascending: true)
        ]
    }

    static var searchSortDescriptor: [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: "year", ascending: true),
            NSSortDescriptor(key: "rating", ascending: false),
            NSSortDescriptor(key: "title", ascending: true)
        ]
    }
}
