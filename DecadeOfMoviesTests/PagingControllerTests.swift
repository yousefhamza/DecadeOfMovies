//
//  PagingControllerTests.swift
//  DecadeOfMoviesTests
//
//  Created by Yousef Hamza on 7/19/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import XCTest

class PagingControllerTests: XCTestCase {
    func testShouldLoadNextPageReturnsFalseWhileLoading() throws {
        // Given
        let pagingController = PagingController()
        pagingController.startLoadingNextPage()

        // When & Then
        XCTAssertFalse(pagingController.shouldLoadNextPage)
    }

    func testShouldLoadNextPageReturnsTrueIfNothingIsLoading() throws {
        // Given
        let pagingController = PagingController()

        // When & Then
        XCTAssertTrue(pagingController.shouldLoadNextPage)
    }

    func testShouldLoadNextPageReturnsFalseIfLastPageIsLoaded() throws {
        // Given
        let pagingController = PagingController()
        pagingController.startLoadingNextPage()

        // When
        pagingController.loadedPage(loadedPageIndex: 1, totalNumberOfPages: 1)

        // Then
        XCTAssertFalse(pagingController.shouldLoadNextPage)
    }

    func testShouldLoadNextPageReturnsTrueIfLastPageNotLoaded() throws {
        // Given
        let pagingController = PagingController()
        pagingController.startLoadingNextPage()

        // When
        pagingController.loadedPage(loadedPageIndex: 1, totalNumberOfPages: 2)

        // Then
        XCTAssertTrue(pagingController.shouldLoadNextPage)
    }

    func testShouldLoadNextPageReturnsFalseIfLastPageNotLoadedButStartedLoading() throws {
        // Given
        let pagingController = PagingController()
        pagingController.startLoadingNextPage()

        // When
        pagingController.loadedPage(loadedPageIndex: 1, totalNumberOfPages: 2)
        pagingController.startLoadingNextPage()

        // Then
        XCTAssertFalse(pagingController.shouldLoadNextPage)
    }
}
