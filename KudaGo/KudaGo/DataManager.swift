//
//  DataManager.swift
//  KudaGo
//
//  Created by Виктория Козырева on 22.06.2021.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
     func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
    
     func getLocation() -> String{
        return UserDefaults.standard.object(forKey: "UserLocation") as? String ?? ""
    }
    
    func setLocation(location: String) {
        UserDefaults.standard.set(location, forKey: "UserLocation")
    }
    
    func getInterests() -> [String]{
        return UserDefaults.standard.object(forKey: "UserInterests") as? [String] ?? []
    }
    
    func setInterests(interests: [String]) {
        UserDefaults.standard.set(interests, forKey: "UserInterests")
    }
}
