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
    let next: String
    let results: [Event]
}

struct Event: Decodable {
    let id: Int
    let dates: [EventDate]
    let title: String
    let images: [Image]
    let price: String
    let body_text: String?
    let age_restriction: String?
    let site_url: String?
    
}

struct EventDate: Decodable {
    let start: Int
    let end: Int
}
struct Image: Decodable {
    let image: String
}

