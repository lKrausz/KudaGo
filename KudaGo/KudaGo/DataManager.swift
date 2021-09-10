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
    
}
