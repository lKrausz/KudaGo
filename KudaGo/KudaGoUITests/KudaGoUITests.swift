//
//  KudaGoUITests.swift
//  KudaGoUITests
//
//  Created by Виктория Козырева on 21.06.2021.
//

import XCTest
@testable import KudaGo

class KudaGoUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
         super.setUp()
         continueAfterFailure = false

         app = XCUIApplication()
         app.launch()
     }

    override func tearDown() {
        super.tearDown()
        app = nil
    }

    func testIsSettingsForSityExists() throws {
        sleep(5) // for network request
        app.tabBars["Tab Bar"].buttons["Настройки"].tap()
        let tablesQuery = app.tables
        tablesQuery.cells.staticTexts["Город"].tap()
        tablesQuery.staticTexts["Санкт-Петербург"].tap()
    }

    func testIsImagesInEventVCExists() throws {
        sleep(5) // for network request
        app.tabBars["Tab Bar"].buttons["События"].tap()
        let tablesQuery = app.tables
        tablesQuery.cells.firstMatch.tap()
        let res = tablesQuery.cells.collectionViews.images.firstMatch.exists
        XCTAssertEqual(res, true)
    }
}
