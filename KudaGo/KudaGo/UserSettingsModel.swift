//
//  UserSettingsModel.swift
//  KudaGo
//
//  Created by Виктория Козырева on 10.09.2021.
//

import Foundation

class UserSettingsModel {
    let currentLocation: String = DataManager.shared.getLocation()
    let currentInterests: [String] = DataManager.shared.getInterests()
    
}
