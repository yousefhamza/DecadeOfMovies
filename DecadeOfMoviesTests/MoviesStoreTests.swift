//
//  MoviesStoreTests.swift
//  DecadeOfMoviesTests
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import XCTest
@testable import DecadeOfMovies
import CoreData

class MoviesStoreTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        MoviesStore.shared.clear()
    }

    func testImportingMoviesFromJSON() throws {
        // Given
        let moviesStore = MoviesStore.shared
        let fetchResultsController = moviesStore.fetchResultsController

        // When
        let expecation = XCTestExpectation()
        moviesStore.importIfNeeded { (error) in
            XCTAssertNil(error)
            expecation.fulfill()
        }
        wait(for: [expecation], timeout: 60)

        // Then
        try fetchResultsController.performFetch()
        XCTAssertEqual(fetchResultsController.sections?.first?.name, "2009")
        XCTAssertEqual(fetchResultsController.sections?.last?.name, "2018")
        XCTAssertEqual(fetchResultsController.sections?.reduce(0, {$0 + $1.numberOfObjects}), 2272)
    }

    func testImportingStateIsPersistedBetweenSessions() {
        let moviesStore = MoviesStore.shared

        // When
        let expecation = XCTestExpectation()
        moviesStore.importIfNeeded { (error) in
            XCTAssertNil(error)
            expecation.fulfill()
        }
        wait(for: [expecation], timeout: 60)

        // Then
        let expecation2 = XCTestExpectation()
        moviesStore.importIfNeeded { (error) in
            XCTAssertEqual(error, MoviesStoreError.alreadyImported)
            expecation2.fulfill()
        }
        wait(for: [expecation2], timeout: 60)
        
    }

    func testImportingMoviesJSONPerformance() throws {
        // Given
        let moviesStore = MoviesStore.shared

        // When
        self.measure {
            moviesStore.clear()
            let expecation = XCTestExpectation()
            moviesStore.importIfNeeded { (error) in
                XCTAssertNil(error)
                expecation.fulfill()
            }
            wait(for: [expecation], timeout: 60)
        }
    }

    func testSearchMovies() throws {
        // Given
        let moviesStore = MoviesStore.shared
        let fetchResultsController = moviesStore.fetchResultsController

        let expecation = XCTestExpectation()
        moviesStore.importIfNeeded { (error) in
            expecation.fulfill()
        }
        wait(for: [expecation], timeout: 60)

        // When
        measure {
            fetchResultsController.fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] 'He'")
            try! fetchResultsController.performFetch()
        }

        // Then
        let newCount = fetchResultsController.sections!.reduce(0, {$0 + $1.numberOfObjects})
        XCTAssertEqual(745, newCount)
    }
}
