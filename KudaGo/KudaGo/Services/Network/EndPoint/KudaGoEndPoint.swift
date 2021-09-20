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
    case eventList(page: Int, pageSize: Int)
    case event(eventId: Int)
}

extension KudaGoAPI: EndPointType {

    var baseUrl: URL {
        guard let url = URL(string: "https://kudago.com/public-api/")
        else { fatalError("baseURL could not be configured.") }
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
        case .event(let eventId):
            return "/events/\(eventId)/"
        }
    }

    var task: HTTPTask {
        switch self {
        case .locations:
            return .requestParams(bodyParams: nil,
                                  urlParams: ["lang": "ru"])
        case .eventCategories:
            return .requestParams(bodyParams: nil,
                                  urlParams: ["lang": "ru"])
        case let .eventList(page, pageSize):
            return .requestParams(bodyParams: nil,
                                  urlParams: ["lang": "ru",
                                              "page": page,
                                              "page_size": pageSize,
                                              "fields": "id,dates,price,title,images,place",
                                              "expand": "place,dates",
                                              "actual_since": Int(Date().timeIntervalSince1970),
                                              "order_by": "publication_date",
                                              "location": DataManager.shared.getLocation(),
                                              "categories": DataManager.shared.getCatedories()
                                  ])
        case .event:
            return .requestParams(bodyParams: nil,
                                  urlParams: ["lang": "ru",
                                              "fields": "id,dates,title,body_text,price,images,site_url,place",
                                              "expand": "place,dates",
                                              "text_format": "plain"
                                  ])
        }
    }

    var HTTPMethod: HTTPMethod {
        return .get
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
