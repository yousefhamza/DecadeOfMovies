//
//  DecadeOfMoviesUITests.swift
//  DecadeOfMoviesUITests
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import XCTest

class DecadeOfMoviesUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testImportingAtLaunch() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.activate()

        XCTAssert(app.navigationBars["Movies"].exists)
        XCTAssert(app.tables.staticTexts["2009"].waitForExistence(timeout: 5))
    }

    func testSearchingMovies() throws {
        let app = XCUIApplication()
        app.launch()
        app.activate()

        XCTAssert(app.navigationBars["Movies"].exists)

        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("Fee")
        let firstSectionTitle = app.tables.staticTexts.element(boundBy: 0)
        let firstRowTitle = app.tables.staticTexts.element(boundBy: 1)

        XCTAssertEqual(firstSectionTitle.label, "2011")
        XCTAssertEqual(firstRowTitle.label, "Happy Feet Two")

        searchBar.typeText("e") // Text is now Feee
        XCTAssertEqual(app.tables.staticTexts.count, 0) // Nothing matches Feee
    }

    func testShowingMovieDetails() throws {
        let app = XCUIApplication()
        app.launch()
        app.activate()

        XCTAssert(app.navigationBars["Movies"].exists)

        app.tables.staticTexts["(500) Days of Summer"].tap()

        XCTAssert(app.staticTexts["(500) Days of Summer"].waitForExistence(timeout: 5))
        XCTAssert(app.staticTexts["2009"].waitForExistence(timeout: 5))
        XCTAssert(app.buttons["Show genres"].waitForExistence(timeout: 5))
    }
}
