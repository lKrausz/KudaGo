//
//  ParameterEncoding.swift
//  KudaGo
//
//  Created by Виктория Козырева on 27.07.2021.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
 static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum NetworkError: String, Error {
    case parametersNil = "Parameters are nil"
    case encodingFailed = "Parameters encoding failed"
    case missingURL = "Missing URL"
}
