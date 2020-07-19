//
//  PagingController.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/19/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import Foundation

class PagingController {
    private var totalNumberOfPages: Int = .max
    private var isLoading = false

    private var hasReachedLastPage: Bool {
        return nextPageIndex > totalNumberOfPages
    }

    /// The index of the next page to load.
    private(set) var nextPageIndex: Int = 1

    /// Check if client should load next page, returns false if loading is already in progress
    /// or client have already reached the last page.
    var shouldLoadNextPage: Bool {
        isLoading == false && hasReachedLastPage == false
    }

    /// Notify controller that you have started loading next page.
    func startLoadingNextPage() {
        isLoading = true
    }

    /// Notif that controller that loading page has ended with information
    /// about what's loaded
    /// - Parameters:
    ///   - loadedPageIndex: The index of the page loaded
    ///   - totalNumberOfPages: The total number of pages
    func loadedPage(loadedPageIndex: Int, totalNumberOfPages: Int) {
        nextPageIndex = loadedPageIndex + 1
        self.totalNumberOfPages = totalNumberOfPages
        isLoading = false
    }

    func finishedWithError() {
        isLoading = false
    }
}
