//
//  EventModel.swift
//  KudaGo
//
//  Created by Виктория Козырева on 17.09.2021.
//

import UIKit
// Общая модель для работы приложения.
// После получения данных из сети/Core data, результат переводится в эту модель.
class EventModel {
    let id: Int32
    let dates: String
    let title: String
    let images: [String]
    let price: String
    let eventDescription: String?
    let url: String?
    let place: String?

    // MARK: Init for network full data model
    init(data: EventFullDescription) {
        self.id = data.eventId
        self.dates = {
            let dataStart = data.dates.last?.startDate ?? ""
            let dataEnd = data.dates.last?.endDate ?? ""

            if dataStart == "" {
                return "Дата: Постоянно"
            } else if dataEnd == "" {
                return "Дата: С \(dataStart)"
            } else {
                return "Дата: C \(dataStart) по \(dataEnd)"
            }
        }()
        self.title = data.title.uppercased()
        self.price = "Цена: " + {
            if data.price == "" {
                return "Бесплатно" } else {
                return data.price
            }
        }()
        self.eventDescription = data.eventDescription
        self.url = "Подробнее: " + data.url
        self.place = "Адрес: " + (data.place?.address ?? "Не указано")
        self.images = {
            var imageArray: [String] = []
            for image in data.images {
                imageArray.append(image.image)
            }
            return imageArray
        }()
    }

    // MARK: Init fore network short data model
    init(data: EventShortDescription) {
        self.id = data.eventId
        self.dates = {
            let dataStart = data.dates.last?.startDate ?? ""
            let dataEnd = data.dates.last?.endDate ?? ""

            if dataStart == "" {
                return "Дата: Постоянно"
            } else if dataEnd == "" {
                return "Дата: С \(dataStart)"
            } else {
                return "Дата: C \(dataStart) по \(dataEnd)"
            }
        }()
        self.title = data.title.uppercased()
        self.price = "Цена: " + {
            if data.price == "" {
                return "Бесплатно" } else {
                return data.price
            }
        }()
        self.eventDescription = nil
        self.url = nil
        self.place = nil
        self.images = {
            var imageArray: [String] = []
            for image in data.images {
                imageArray.append(image.image)
            }
            return imageArray
        }()
    }
    
    // MARK: Init for core data entity
    init(data: EventEntity) {
        self.id = data.id
        self.dates = data.dates
        self.title = data.title
        self.images = data.images
        self.price = data.price
        self.eventDescription = data.eventDesc
        self.url = data.url
        self.place = data.place
    }
}
