// Kevin Li - 7:56 PM - 2/22/20

import Foundation
import Combine
import CoreData

class DataSource<T: NSManagedObject>: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    let objectWillChange = ObservableObjectPublisher()

    private var sortKey1: String?
    private var sortAscending1: Bool = true
    private var sortKey2: String?
    private var sortAscending2: Bool = true
    private var sectionNameKeyPath: String?

    private var predicate: NSPredicate?

    override init() {
        super.init()

        self.sortKey1 = nil
        self.sortKey2 = nil
        self.sectionNameKeyPath = nil

        self.predicate = nil
    }

    init(sortKey1: String?) {
        super.init()

        self.sortKey1 = sortKey1
        self.sortKey2 = nil
        self.sectionNameKeyPath = nil

        self.predicate = nil
    }

    init(sortKey1: String?, sortKey2: String?) {
        super.init()

        self.sortKey1 = sortKey1
        self.sortKey2 = sortKey2
        self.sectionNameKeyPath = nil

        self.predicate = nil
    }

    init(predicate: NSPredicate?) {
        super.init()

        self.sortKey1 = nil
        self.sortKey2 = nil
        self.sectionNameKeyPath = nil

        self.predicate = predicate
    }

    private lazy var fetchRequest: NSFetchRequest<T> = {
        configureFetchRequest()
    }()

    private lazy var frc: NSFetchedResultsController<T> = {
        configureFetchedResultsController()
    }()

    private func configureFetchRequest() -> NSFetchRequest<T> {
        let fetchRequest = T.fetchRequest() as! NSFetchRequest<T>
        fetchRequest.fetchBatchSize = 0

        if let sortKey1 = sortKey1 {
            if let sortKey2 = sortKey2 {
                let sortDescriptor1 = NSSortDescriptor(key: sortKey1, ascending: sortAscending1)
                let sortDescriptor2 = NSSortDescriptor(key: sortKey2, ascending: sortAscending2)
                fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
            } else {
                let sortDescriptor = NSSortDescriptor(key: sortKey1, ascending: self.sortAscending1)
                fetchRequest.sortDescriptors = [sortDescriptor]
            }
        }

        if let predicate = predicate {
            fetchRequest.predicate = predicate
        } else {
            fetchRequest.predicate = nil
        }

        return fetchRequest
    }

    private func configureFetchedResultsController() -> NSFetchedResultsController<T> {
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreData.stack.context,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: nil)
        frc.delegate = self

        return frc
    }

    private func performFetch() {
        do {
            try self.frc.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

extension DataSource {
    var fetchedObjects: [T] {
        return frc.fetchedObjects ?? []
    }

    var allInOrder:[T] {
        self.performFetch()
        return self.fetchedObjects
    }
}

extension DataSource {
    func fetch() -> [T] {

        do {
            let objects = try CoreData.stack.context.fetch(self.fetchRequest)
            return objects
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
            return [T]()
        }
    }

    func loadDataSource() {
        self.objectWillChange.send()
        self.performFetch()
    }

    func loadDataSource(predicate: NSPredicate?) -> [T] {
        self.predicate = predicate
        self.fetchRequest = configureFetchRequest()
        self.frc = configureFetchedResultsController()

        return self.allInOrder
    }

    func changeSort(key: String, ascending: Bool) {
        self.sortKey1 = key
        self.sortAscending1 = ascending
        self.fetchRequest = configureFetchRequest()
        self.frc = configureFetchedResultsController()

        self.loadDataSource()
    }


}
