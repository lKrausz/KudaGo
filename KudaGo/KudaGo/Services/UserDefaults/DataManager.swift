//
//  DataManager.swift
//  KudaGo
//
//  Created by Виктория Козырева on 22.06.2021.
//

import Foundation
//MARK: Менеджер работы с UserDefaults
class DataManager {
    static let shared = DataManager()

     func getIsNewUserStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: "isNewUser")
    }

    func setIsNewUserStatus() {
        UserDefaults.standard.set(false, forKey: "isNewUser")
    }

     func getLocation() -> String {
        return UserDefaults.standard.object(forKey: "UserLocation") as? String ?? ""
    }

    func setLocation(location: String) {
        UserDefaults.standard.set(location, forKey: "UserLocation")
    }

    func getCatedories() -> String {
        return UserDefaults.standard.object(forKey: "UserCategories") as? String ?? ""
    }

    func setCategories(categories: String) {
        UserDefaults.standard.set(categories, forKey: "UserCategories")
    }
}
