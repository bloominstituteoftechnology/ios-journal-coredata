
import Foundation
import CoreData


class EntryController {
    
    typealias CompletionHandler = (Error?)  -> Void
    
    let baseURL = URL(string: "https://journal-76acd.firebaseio.com/")!
    
    // MARK: - Core Data Functions
    
    func createEntry(title: String, bodyText: String, mood: String) {
        
        // Initialize an Entry object
        let newEntry = Entry(context: CoreDataStack.shared.mainContext)

        newEntry.title = title
        newEntry.bodyText = bodyText
        newEntry.mood = mood
        newEntry.timestamp = Date()
        
        // Save to the persistent store
        saveToPersistentStore()
        
        // Save to the server (PUT)
        put(entry: newEntry)
        
    }
    
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
        
        // Save to the server (PUT)
        put(entry: entry)
        
    }
    
    func deleteEntry(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        
        // Save this deletion to the server
        deleteEntryFromServer(entry: entry)
        
        // Save this deletion to the persistent store
        saveToPersistentStore()
    
    }
    
    // MARK: - Firebase Functions
    
    // Save to server
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        // Append identifier of the entry parameter to the baseURL
        do {
            var uuid = entry.identifier
            
            if uuid == nil {
                uuid = UUID().uuidString
                entry.identifier = uuid
                self.saveToPersistentStore()
            }
            
            let requestURL = baseURL.appendingPathComponent(uuid!).appendingPathExtension("json")
            
            var request = URLRequest(url: requestURL)
            request.httpMethod = "PUT"
            
            let body = try JSONEncoder().encode(entry)
            request.httpBody = body
            
            URLSession.shared.dataTask(with: request) { (_, _, error) in
                if let error = error {
                    NSLog("Error saving entry: \(error)")
                }
                completion(error)
            }.resume()
            
        } catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
    }
    
    // Takes an Entry whose values should be updated, and and Entry Representation to take the values from
    func update(entry: Entry, with entryRepresentation: EntryRepresentation) {
        guard entry.identifier == entryRepresentation.identifier else {
            fatalError("Updating the wrong task!")
        }
        
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.timestamp = entryRepresentation.timestamp
        entry.identifier = entryRepresentation.identifier
        entry.mood = entryRepresentation.mood
        
    }
    
    // Fetch from Core Data
    func fetchSingleEntryFromPersistentStore(identifier: String) -> Entry? {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        request.predicate = predicate
        
        let moc = CoreDataStack.shared.mainContext
        
        // Return first entry from the array  - in theory, there should only be one entry fetched anyway b/c the predicate uses the entry's identifier.
        let entry = (try? moc.fetch(request))?.first
        
        return entry
    }
    
    // Fetch from Server
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        // Perform a GET URLSessionDataTask with url just set up
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from the data task")
                completion(NSError())
                return
            }
            
            var dataArray: [EntryRepresentation] = []
            
            DispatchQueue.main.async {
                do {
                    dataArray = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map({$0.value})
                    
                    
                } catch {
                    
                }
            }
            
            
            
            
            
            
        }
        
        
    }
    
    
    // Delete from server
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        // Make sure there is an identifier to delete
        guard let uuid = entry.identifier else { return }
        
        // Append identifier of the entry parameter to the baseURL
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
            
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
            
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting entry: \(error)")
            }
            completion(error)
        }.resume()
    }
    

    
    

    
}
