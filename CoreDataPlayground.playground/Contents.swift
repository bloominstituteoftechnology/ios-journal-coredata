import UIKit
import CoreData

class CoreDataStack {

static let shared = CoreDataStack()
let container: NSPersistentContainer
let mainContext: NSManagedObjectContext

init() {
    container = NSPersistentContainer(name: "JournalCoreData")
    container.loadPersistentStores { (description, error) in
        if let error = error {
            fatalError("could not load the data store: \(error)")
        } else {
            print("\(description)")
        }
    }
    mainContext = container.viewContext
    mainContext.automaticallyMergesChangesFromParent = true
}

let predicate = NSPredicate(format: "title = %@", "Item List")
let predicate2 = NSPredicate(format: "identifier >= $@", 20000)
let predicate3 = NSPredicate(format: "title contains[cd] $@", "good")
    
    func combinePredicates() {
        let fetchRequest: NSFetchRequest = NSFetchRequest
    }

}
