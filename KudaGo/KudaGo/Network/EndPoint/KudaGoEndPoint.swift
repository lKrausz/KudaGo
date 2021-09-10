//
//  KudaGoEndPoint.swift
//  KudaGo
//
//  Created by Виктория Козырева on 27.07.2021.
//

import Foundation

public enum KudaGoAPI {
    case locations
    case eventCategories
}

extension KudaGoAPI: EndPointType {
    
    var baseUrl: URL {
        guard let url = URL(string: "https://kudago.com/public-api/") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .locations:
            return  "/locations"
        case .eventCategories:
            return  "/event-categories"
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .locations:
            return .requestParams(bodyParams: nil,
                                  urlParams: ["lang":"ru"])
        case .eventCategories:
            return .requestParams(bodyParams: nil,
                                  urlParams: ["lang":"ru"])
        }
    }
    
    var HTTPMethod: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
