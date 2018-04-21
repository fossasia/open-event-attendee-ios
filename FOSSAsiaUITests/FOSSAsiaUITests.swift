//
//  FOSSAsiaUITests.swift
//  FOSSAsiaUITests
//
//  Created by Jurvis Tan on 6/3/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import XCTest

class FOSSAsiaUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let app = XCUIApplication()

        snapshot("0Launch")
        snapshot("1Event")
        snapshot("2AddToCalendar")

        let tabBarsQuery = app.tabBars
        tabBarsQuery.children(matching: .button).element(boundBy: 1).tap()
        snapshot("3Favorites")
        tabBarsQuery.children(matching: .button).element(boundBy: 2).tap()
        snapshot("4More")
    }
}
