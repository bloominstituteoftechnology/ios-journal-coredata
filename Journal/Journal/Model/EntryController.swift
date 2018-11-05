import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            moc.reset()
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
    }
    
    func createEntry(title: String, bodyText: String, timestamp: Date = Date(), identifier: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        _ = Entry(title: title, bodyText: bodyText, identifier: identifier)
        
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, timestamp: Date = Date()) {
        
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        saveToPersistentStore()
    }
}
