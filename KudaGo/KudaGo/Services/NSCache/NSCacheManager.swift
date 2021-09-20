//
//  NSCacheManager.swift
//  KudaGo
//
//  Created by Виктория Козырева on 20.09.2021.
//

import UIKit

class NSCacheManager {
    static let shared = NSCacheManager()

    let cache = NSCache<NSString, UIImage>()
}
