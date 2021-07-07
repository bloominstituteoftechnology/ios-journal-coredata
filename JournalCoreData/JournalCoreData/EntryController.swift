import Foundation
import CoreData

class EntryController {
    
    func saveToPersistentStore(){
        // save data to mainContext
        do {
            try CoreDataStack.shared.mainContext.save()
        }catch {
            print("failed to save: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry]{
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let results = (try? CoreDataStack.shared.mainContext.fetch(fetchRequest)) ?? []
        print(results)
        return results
    }
    
    var entries: [Entry]? {
        return loadFromPersistentStore()
        
    }
    
    func createEntry(title: String, entryBody: String?){
        print("did we make it to the create func?") // FIXME: never even getting here
        _ = Entry(title: title, bodyText: entryBody ?? "", context: CoreDataStack.shared.mainContext)
        
        print("this should be creating a new entry.")
        saveToPersistentStore()
        
    }
    
    func updateEntry(entryTitle: String, entryBodyText: String, entry: Entry){
        entry.title = entryTitle
        entry.bodyText = entryBodyText
        entry.timeStamp = Date()
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry){
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
}
