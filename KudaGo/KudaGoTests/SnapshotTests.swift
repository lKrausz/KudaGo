//
//  SnapshotTests.swift
//  KudaGoTests
//
//  Created by Виктория Козырева on 19.09.2021.
//

import SnapshotTesting
import XCTest

class SnapshotTests: XCTestCase {

    func testSettingsController() {
       let viewController = SettingsViewController()

        assertSnapshot(matching: viewController, as: .image(on: .iPhoneSe))
    }

}
