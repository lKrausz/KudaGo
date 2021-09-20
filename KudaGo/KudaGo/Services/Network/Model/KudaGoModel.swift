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
    let count: Int
    let results: [EventShortDescription]
}

struct EventShortDescription {
    let eventId: Int32
    let dates: [EventDate]
    let title: String
    let images: [Image]
    let price: String
}

extension EventShortDescription: Decodable {

    private enum EventCodingKeys: String, CodingKey {
        case eventId = "id"
        case dates
        case title
        case price
        case images

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EventCodingKeys.self)

        eventId = try container.decode(Int32.self, forKey: .eventId)
        dates = try container.decode([EventDate].self, forKey: .dates)
        title = try container.decode(String.self, forKey: .title)
        price = try container.decode(String.self, forKey: .price)
        images = try container.decode([Image].self, forKey: .images)
    }
}

struct EventFullDescription {
    let eventId: Int32
    let dates: [EventDate]
    let title: String
    let images: [Image]
    let price: String
    let eventDescription: String
    let url: String
    let place: Place?
}

extension EventFullDescription: Decodable {

    private enum EventCodingKeys: String, CodingKey {
        case eventId = "id"
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

        eventId = try container.decode(Int32.self, forKey: .eventId)
        dates = try container.decode([EventDate].self, forKey: .dates)
        title = try container.decode(String.self, forKey: .title)
        price = try container.decode(String.self, forKey: .price)
        images = try container.decode([Image].self, forKey: .images)
        eventDescription = try container.decode(String.self, forKey: .eventDescription)
        url = try container.decode(String.self, forKey: .url)
        place = try container.decode(Place?.self, forKey: .place)
    }
}

struct Place: Decodable {
    let address: String
}

struct EventDate {
    let startDate: String?
    let startTime: String?
    let endDate: String?
    let endTime: String?
}

extension EventDate: Decodable {

    private enum EventCodingKeys: String, CodingKey {
        case startDate = "start_date"
        case startTime = "start_time"
        case endDate = "end_date"
        case endTime = "end_time"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EventCodingKeys.self)

        startDate = try container.decode(String?.self, forKey: .startDate)
        startTime = try container.decode(String?.self, forKey: .startTime)
        endDate = try container.decode(String?.self, forKey: .endDate)
        endTime = try container.decode(String?.self, forKey: .endTime)
    }
}

struct Image: Decodable {
    let image: String
}
