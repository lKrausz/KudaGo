//
//  KudaGoModel.swift
//  KudaGo
//
//  Created by Виктория Козырева on 27.07.2021.
//
struct OnboardingApiResponse: Decodable {
    let name: String
    let slug: String
}

struct EventsApiResponse: Decodable {
    let results: [Event]
}

struct Event: Decodable {
    let id: UInt64
    let dates: [EventDate]
    let title: String
    let images: [Image]
    let price: String
    let place: Place

}

struct EventFullDesc {
    let dates: [EventDate]
    let title: String
    let images: [Image]
    let price: String
    let eventDescription: String
    let url: String
    let place: Place?
}

extension EventFullDesc: Decodable {
    
    private enum EventCodingKeys: String, CodingKey {
        case dates
        case title
        case price
        case place
        case images
        case eventDescription = "body_text"
        case url = "site_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EventCodingKeys.self)
        
        dates = try container.decode([EventDate].self, forKey: .dates)
        title = try container.decode(String.self, forKey: .title)
        price = try container.decode(String.self, forKey: .price)
        images = try container.decode([Image].self, forKey: .images)
        eventDescription = try container.decode(String.self, forKey: .eventDescription)
        url = try container.decode(String.self, forKey: .url)
        place = try container.decode(Place.self, forKey: .place)


    }
}

struct Place: Decodable {
    let address: String
}

struct EventDate: Decodable {
    let start_date: String?
    let start_time: String?
    let end_date: String?
    let end_time: String?
}
struct Image: Decodable {
    let image: String
}

