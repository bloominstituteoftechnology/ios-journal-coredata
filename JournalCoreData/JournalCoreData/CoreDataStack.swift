
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
        
        mainContext = container.viewContext
    }
}
