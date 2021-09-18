//
//  DataBaseDataManager.swift
//  KudaGo
//
//  Created by Виктория Козырева on 16.09.2021.
//

import Foundation
import CoreData

class DataBaseManager {
    static let shared = DataBaseManager()

    var fetchedResultsController: NSFetchedResultsController<EventDescription>!

    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "KudaGo")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func context() -> NSManagedObjectContext {
        return DataBaseManager.shared.persistentContainer.viewContext
    }
//    
//    func abc() {
//        let results = context().fetch(NSFetchRequest.init(entityName: "").)
//    }

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

    func addItems() {
        loadData()
      do {
        NSFetchedResultsController<EventDescription>.deleteCache(withName: fetchedResultsController.cacheName)
        try fetchedResultsController.performFetch()
      } catch {
        print("Perform fetch failed")
      }
    }

    func loadData() {
        if fetchedResultsController == nil {

            let request = EventDescription.fetchRequest() as NSFetchRequest<EventDescription>
            request.sortDescriptors = []

            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataBaseManager.shared.context(), sectionNameKeyPath: nil, cacheName: "CACHENAME")
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

    func deleteItem(index: IndexPath) {
        let removeTask = self.fetchedResultsController.object(at: index)
        DataBaseManager.shared.context().delete(removeTask)
        DataBaseManager.shared.saveContext()
        self.loadData()
    }
}
