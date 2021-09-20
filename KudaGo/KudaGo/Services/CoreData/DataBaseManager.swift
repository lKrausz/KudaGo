//
//  DataBaseDataManager.swift
//  KudaGo
//
//  Created by Виктория Козырева on 16.09.2021.
//

import Foundation
import CoreData

//MARK: Менеджер работы с Core Data
class DataBaseManager {
    static let shared = DataBaseManager()

    var fetchedResultsController: NSFetchedResultsController<EventEntity>!

    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "KudaGo")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func context() -> NSManagedObjectContext {
        return DataBaseManager.shared.persistentContainer.viewContext
    }

    func saveContext() {
        if context().hasChanges {
            do {
                try context().save()
            } catch {
                context().rollback()
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func loadData() {
        if fetchedResultsController == nil {

            let request = EventEntity.fetchRequest() as NSFetchRequest<EventEntity>
            request.sortDescriptors = []

            fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                managedObjectContext: DataBaseManager.shared.context(),
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: "CACHENAME")
        }
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Fetch failed")
        }
        DispatchQueue.main.async {
           // self.tableView.reloadData()
        }
    }

    func addElement(element: EventModel) {
        let newBookmark = EventEntity(context: DataBaseManager.shared.context())

        newBookmark.id = Int32(element.id)
        newBookmark.dates = element.dates
        newBookmark.eventDesc = element.eventDescription
        newBookmark.images = element.images
        newBookmark.place = element.place
        newBookmark.title = element.title
        newBookmark.url = element.url
        newBookmark.price = element.price

        DataBaseManager.shared.saveContext()
        DataBaseManager.shared.loadData()
    }

    func isInDataBase(eventID: Int) -> Bool {
        let request = EventEntity.fetchRequest() as NSFetchRequest<EventEntity>

        let idPredicate = NSPredicate(format: "id LIKE %@", "\(eventID)")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate])
        do {
            let result = try context().fetch(request)
            if result.isEmpty {
                return false
            } else {
                return true
            }
        } catch {
            return false
        }
    }

    func deleteItem(index: IndexPath) {
        let removeTask = self.fetchedResultsController.object(at: index)
        DataBaseManager.shared.context().delete(removeTask)
        DataBaseManager.shared.saveContext()
        self.loadData()
    }
}
