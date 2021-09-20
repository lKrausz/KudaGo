//
//  PageObjectTests.swift
//  KudaGoUITests
//
//  Created by Виктория Козырева on 20.09.2021.
//

import XCTest

class PageObjectTests: XCTestCase {
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

    func testLocationSettingCellsExists() throws {

        let tabBarPage = TabBarPage(app: app)
        let settingPage = tabBarPage
            .tapSettingsTab()
            .tapSitySettingCell()

        XCTAssertTrue(settingPage.sityCell.exists)
    }
}

protocol Page {
    var app: XCUIApplication { get }
    init(app: XCUIApplication)
}

class TabBarPage: Page {
    var app: XCUIApplication
    var settingsTab: XCUIElement { return app.tabBars.buttons["Настройки"] }

    required init(app: XCUIApplication) {
        self.app = app
    }

    func tapSettingsTab() -> SettingsPage {
        settingsTab.tap()
        return SettingsPage(app: app)
    }
}

class SettingsPage: Page {
    var app: XCUIApplication
    var sitySettingCell: XCUIElement { return app.tables.cells.staticTexts["Город"] }

    required init(app: XCUIApplication) {
        self.app = app
    }

    func tapSitySettingCell() -> SettingPage {
        sitySettingCell.tap()
        return SettingPage(app: app)
    }
}

class SettingPage: Page {
    var app: XCUIApplication

    var sityCell: XCUIElement { return app.tables.cells.firstMatch }

    required init(app: XCUIApplication) {
        self.app = app
    }
}
