
import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    let container: NSPersistentContainer
    let mainContext: NSManagedObjectContext
    
    init() {
        
        container = NSPersistentContainer(name: "JournalEntries")
        container.loadPersistentStores { (description, error) in
            if let e = error {
                fatalError("Couldnt load the data store: \(e)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        mainContext = container.viewContext
    }
    
    func save(context: NSManagedObjectContext) throws {
        var saveError: Error?
        context.performAndWait {
            do {
                try context.save()
            } catch {
                saveError = error
            }
        }
        
        if let saveError = saveError {
            throw saveError
        }
    }
}
