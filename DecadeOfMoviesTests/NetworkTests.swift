//
//  NetworkTests.swift
//  DecadeOfMoviesTests
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import XCTest

class NetworkTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSuccessRequest() throws {
        // When
        let exepctation = XCTestExpectation()
        Network.shared.executeRequest(at: URLRequestCreatorMock(urlPath: "https://httpbin.org/get"),
                                      successCallback: { (response: HTTPPinResponse) in
                                        // Then
                                        XCTAssertEqual(response.url, "https://httpbin.org/get")
                                        exepctation.fulfill()
        },
                                      errorCallback: { (error) in })
        wait(for: [exepctation], timeout: 5)
    }

    func testClientErrorRequest() throws {
        // When
        let exepctation = XCTestExpectation()
        Network.shared.executeRequest(at: URLRequestCreatorMock(urlPath: "https://asdasjdasiodjqwoeqwe.com"),
                                      successCallback: { (response: HTTPPinResponse) in
        },
                                      errorCallback: { (error) in
                                        // Then
                                        XCTAssertEqual(error, .clientError)
                                        exepctation.fulfill()
        })
        wait(for: [exepctation], timeout: 5)
    }

    func testServerErrorRequest() {
        // When
        let exepctation = XCTestExpectation()
        Network.shared.executeRequest(at: URLRequestCreatorMock(urlPath: "https://httpbin.org/status/500"),
                                      successCallback: { (response: HTTPPinResponse) in },
                                      errorCallback: { (error) in
                                        // Then
                                        XCTAssertEqual(error, .serverError)
                                        exepctation.fulfill()
        })
        wait(for: [exepctation], timeout: 5)
    }
}
