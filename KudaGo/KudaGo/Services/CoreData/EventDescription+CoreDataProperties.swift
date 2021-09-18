//
//  EventDescription+CoreDataProperties.swift
//  KudaGo
//
//  Created by Виктория Козырева on 17.09.2021.
//
//

import Foundation
import CoreData

extension EventDescription {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventDescription> {
        return NSFetchRequest<EventDescription>(entityName: "EventDescription")
    }

    @NSManaged public var dates: String
    @NSManaged public var title: String
    @NSManaged public var price: String
    @NSManaged public var place: String?
    @NSManaged public var images: [String]
    @NSManaged public var eventDesc: String?
    @NSManaged public var url: String?
    @NSManaged public var id: Int32

}

extension EventDescription: Identifiable {

}
