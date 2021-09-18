//
//  EndPointType.swift
//  KudaGo
//
//  Created by Виктория Козырева on 27.07.2021.
//

import Foundation

protocol EndPointType {
    var baseUrl: URL { get }
    var path: String { get }
    var task: HTTPTask { get }
    var HTTPMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
}
