//
//  HTTPTask.swift
//  KudaGo
//
//  Created by Виктория Козырева on 27.07.2021.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
    case request
    case requestParams(bodyParams: Parameters?, urlParams: Parameters?)
}
