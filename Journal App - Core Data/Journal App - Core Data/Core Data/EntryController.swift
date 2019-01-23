
import Foundation
import CoreData


class EntryController {
    
    // Saves core data stack's mainContext
    // This will bundle the changes in the context, pass them to the persistent store coordinator, who will then put those changes in the persistent store.
    func saveToPersistentStore() {
        
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            fatalError("Error saving to core data: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        
        var entry: [Entry] {
            
            do {
                // Create NSFetchRequest for Entry objects
                let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
                
                // Fetch request happens on the core data stack's mainContext
                let result = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
                
                // Return results
                return result
                
            } catch {
                fatalError("Cant fetch Data \(error)")
            }
        }
        return entry
    }
    


    var entries: [Entry] {
    
    // This allows any changes to the persistent store to become imediately visible when accessing the array (i.e. in the table view showing a list of entries)
        return loadFromPersistentStore()
    }
    
    
    func createEntry(title: String, bodyText: String, mood: String) {
        
        // Initialize an Entry object
        let newEntry = Entry(context: CoreDataStack.shared.mainContext)

        newEntry.title = title
        newEntry.bodyText = bodyText
        newEntry.mood = mood
        newEntry.timestamp = Date()
        
        // Save to the persistent store
        saveToPersistentStore()
        
    }
    
    // Have title and bodyText parameters as well as the Entry you want to update
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) {
        
        // Change the title and bodyText of the Entry to the new values passed in as parameters to the function
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood

        // Update the entry's timestamp to the current time
        entry.timestamp = Date.init()
        
        // Save changes to the persistent store
        saveToPersistentStore()
        
    }
    
    
    func deleteEntry(entry: Entry) {
        
        CoreDataStack.shared.mainContext.delete(entry)
        
        // Save this deletion to the persistent store
        saveToPersistentStore()
        
    }
    

    
    

    
}
