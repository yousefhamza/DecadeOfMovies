//
//  MoviesStore+TestHelpers.swift
//  DecadeOfMoviesTests
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import Foundation
import XCTest
import CoreData

extension MoviesStore {
    func clear() {
        persistentContainer.viewContext.performAndWait { [weak self] () in
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: MovieMO.fetchRequest())
            try! persistentContainer.viewContext.execute(batchDeleteRequest)
            self?.hasImportedData = false
        }
    }
}
