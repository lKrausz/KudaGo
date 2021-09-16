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
    case eventList(page: Int, page_size: Int)
    case event(id: Int)
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
        case .eventList:
            return "/events/"
        case .event(let id):
            return "/events/\(id)/"
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
        case .eventList(let page, let page_size):
            return .requestParams(bodyParams: nil,
                                  urlParams: ["lang":"ru", "page": page, "page_size": page_size, "fields": "id,dates,price,title,images,place","expand":"place,dates","actual_since": Int(Date().timeIntervalSince1970),"order_by": "publication_date", "location": "spb"])//DataManager.shared.getLocation()])
        case .event:
            return .requestParams(bodyParams: nil,
                                  urlParams: ["lang":"ru", "fields": "dates,title,body_text,age_restriction,price,images,site_url,place","expand":"place,dates", "text_format": "plain"])
        }
    }
    
    var HTTPMethod: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
