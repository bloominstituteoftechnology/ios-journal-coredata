import Foundation
import CoreData

class EntryController {
    
    func saveToPersistentStore(){
        // save data to mainContext
        try! CoreDataStack.shared.mainContext.save()
    }
    
    func loadFromPersistentStore() -> [Entry]{
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let results = (try? CoreDataStack.shared.mainContext.fetch(fetchRequest)) ?? []
        return results
    }
    
    var entries: [Entry]? {
        didSet {
            loadFromPersistentStore()
        }
    }
    
    func createEntry(){
        _ = Entry(context: CoreDataStack.shared.mainContext)
        do {
            try CoreDataStack.shared.mainContext.save()
            //navigationController?.popViewController(animated: true)
        }catch {
            print("Failed to save: \(error)")
        }
    }
    
    func updateEntry(entryTitle: String, entryBodyText: String, entry: Entry){
        entry.title = entryTitle
        entry.bodyText = entryBodyText
        entry.timeStamp = Date()
        do {
            try CoreDataStack.shared.mainContext.save()
            //navigationController?.popViewController(animated: true)
        }catch {
            print("Failed to save: \(error)")
        }
    }
    
    func deleteEntry(entry: Entry){
        CoreDataStack.shared.mainContext.delete(entry)
        do {
            try CoreDataStack.shared.mainContext.save()
            //navigationController?.popViewController(animated: true)
        }catch {
            print("Failed to save: \(error)")
        }
    }
}
