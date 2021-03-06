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
        app.launchArguments = ["clear"]
        app.launch()

        app.buttons["Import Movies"].tap()
        XCTAssert(app.tables.staticTexts["2009"].waitForExistence(timeout: 5))
    }

    func testSearchingMovies() throws {
        let app = XCUIApplication()
        app.launch()
        importIfNeeded()

        XCTAssert(app.navigationBars["Movies"].exists)

        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("Fee")
        let firstSectionTitle = app.tables.staticTexts.element(boundBy: 0)
        let firstRowTitle = app.tables.staticTexts.element(boundBy: 1)

        XCTAssertEqual(firstSectionTitle.label, "2011")
        XCTAssertEqual(firstRowTitle.label, "Happy Feet Two")

        searchBar.typeText("e") // Text is now Feee
        XCTAssert(app.staticTexts["No movies are matching your search query"].waitForExistence(timeout: 5))
    }

    func testShowingMovieDetails() throws {
        let app = XCUIApplication()
        app.launch()
        importIfNeeded()

        XCTAssert(app.navigationBars["Movies"].exists)

        app.tables.staticTexts["(500) Days of Summer"].tap()

        XCTAssert(app.navigationBars["Details"].exists)
        XCTAssert(app.staticTexts["(500) Days of Summer"].waitForExistence(timeout: 5))
        XCTAssert(app.staticTexts["2009"].waitForExistence(timeout: 5))

        XCTAssert(app.collectionViews.staticTexts["Comedy"].exists)
        XCTAssert(app.tables.staticTexts["Zooey Deschanel"].exists)
    }

    func testMoviePhotosPaging() throws {
        let app = XCUIApplication()
        app.launch()
        importIfNeeded()

        XCTAssert(app.navigationBars["Movies"].exists)

        app.tables.staticTexts["(500) Days of Summer"].tap()

        XCTAssert(app.navigationBars["Details"].exists)
        app.buttons["Show images from Flicker"].tap()

        XCTAssert(app.navigationBars["Flicker Images"].exists)
        XCTAssert(app.collectionViews.cells.element(boundBy: 0).waitForExistence(timeout: 5))
        XCTAssertLessThan(app.collectionViews.cells.count, 10)

        app.collectionViews.element(boundBy: 0).swipeUp()
        XCTAssert(app.collectionViews.cells.element(boundBy: 11).waitForExistence(timeout: 5))
        XCTAssertGreaterThan(app.collectionViews.cells.count, 10)
    }

    func importIfNeeded() {
        let app = XCUIApplication()
        let importButton = app.buttons["Import Movies"]
        if importButton.exists == false {
            return
        }
        importButton.tap()
        XCTAssert(waitForMoviesToAppear())
    }

    func waitForMoviesToAppear() -> Bool{
        XCUIApplication().tables.staticTexts["2009"].waitForExistence(timeout: 5)
    }
}
