import Foundation
import CoreData

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    //MARK: Firebase
    typealias CompletionHandler = (Error?) -> Void
    var entryRepresentations: [EntryRepresentation] = []
    
    private let baseURL = URL(string: "https://journal-coredata-f20ba.firebaseio.com/")!
    //let moc = CoreDataStack.shared.mainContext
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }){
        let id = entry.identifier
        let requestURL = baseURL.appendingPathComponent(id!).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            // guard let representation = entry.entryRepresentation else { throw NSError() }
            request.httpBody = try JSONEncoder().encode(entry)
            
        }catch {
            print("error saving task: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("error putting task: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            return
            }.resume()
        
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }){
        let id = entry.identifier
        
        let requestURL = baseURL.appendingPathComponent(id!).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("error deleting task: \(error)")
            }
            completion(error)
            return
            }.resume()
        
        
        //        do {
        //            //guard let representation = entry.entryRepresentation else { throw NSError() }
        //            request.httpBody = try JSONEncoder().encode(entry)
        //        }catch {
        //            print("error saving task: \(error)")
        //            completion(error)
        //            return
        //        }
    }
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation){
        guard let context = entry.managedObjectContext else { return }
        
        context.perform {
            guard entry.identifier == entryRepresentation.identifier else {
                fatalError("update failed. updating wrong entry.")
            }
            
            entry.bodyText = entryRepresentation.bodyText
            entry.title = entryRepresentation.title
            entry.timeStamp = entryRepresentation.timeStamp
            entry.identifier = entryRepresentation.identifier
            entry.mood = entryRepresentation.mood
        }
        
    }
    
    func fetchSingleEntryFromPersistentStore(with identifier: String, in managedObjectContext: NSManagedObjectContext) -> Entry? {
        
        let predicate = NSPredicate(format: "identifier == %@", identifier as String)
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = predicate
        
        var entry: Entry?
        
        managedObjectContext.performAndWait {
            entry = (try? managedObjectContext.fetch(fetchRequest))?.first
        }
        
        return entry
    }
    
    func fetchEntriesFromServer(completionHandler: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) {(data, _, error) in
            
            if let error = error {
                print("error fetching entry: \(error)")
                completionHandler(error)
                return
            }
            
            guard let data = data else {
                print("no data returned")
                completionHandler(NSError())
                return
            }
            
            let moc = CoreDataStack.shared.container.newBackgroundContext()
            
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode([String: EntryRepresentation].self, from: data)
                let entryRepresentations = Array(decodedResponse.values)
                try self.updatePersistentStore(entryRepresentations, into: moc)
                try CoreDataStack.shared.save(context: moc)
                completionHandler(nil)
                
            }catch {
                print("error importing entries: \(error)")
                completionHandler(error)
                return
            }
            
            }.resume()
    }
    
    //update persistent store
    func updatePersistentStore(_ entryRepresentations: [EntryRepresentation], into managedObjectContext: NSManagedObjectContext) throws {
        
        var importedEntryIdentifiers = Set<String>()
        for entryRepresentation in entryRepresentations {
            if let identifier = entryRepresentation.identifier, let entry = fetchSingleEntryFromPersistentStore(with: identifier, in: managedObjectContext) {
                
//                if entry != entryRepresentation {
                    update(entry: entry, entryRepresentation: entryRepresentation)
//                }
            } else {
                
                managedObjectContext.perform {
                    _ = Entry(entryRepresentation: entryRepresentation, moc: managedObjectContext)

                }
            }
        }
        
        let query: NSFetchRequest<NSFetchRequestResult> = Entry.fetchRequest()
        
        // find all the tasks with identifiers that were NOT updated
        query.predicate = NSPredicate(format: "identifier != NULL AND NOT(identifier IN %@)", importedEntryIdentifiers)
        
        let batchDelete = NSBatchDeleteRequest(fetchRequest: query)
        
        managedObjectContext.perform {
            _ = try? managedObjectContext.execute(batchDelete)
        }
        //saveToPersistentStore()
    }
    
    
    func saveToPersistentStore(){
        // save data to mainContext
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.container.newBackgroundContext())
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
    
    //CREATE
    public func create(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let bodyText = entryRepresentation.bodyText
        let title = entryRepresentation.title
        let timeStamp = entryRepresentation.timeStamp
        let identifier = entryRepresentation.identifier
        let mood = entryRepresentation.mood
        
        //create movie from representation
        let entry = Entry(title: title!, bodyText: bodyText!, timeStamp: timeStamp ?? Date(), identifier: identifier ?? UUID().uuidString, mood: mood!)
        
        //save it to moc
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving created movie: \(error)")
            return
        }
        
        //save it to Firebase
        put(entry: entry)
    }
    func createEntry(title: String, entryBody: String?, mood: String, in managedObjectContext: NSManagedObjectContext){
        
        managedObjectContext.perform {
            let newEntry = Entry(title: title, bodyText: entryBody ?? "", identifier: UUID().uuidString, mood: mood, context: managedObjectContext)
            self.put(entry: newEntry)
        }
        
//        put(entry: newEntry)
        saveToPersistentStore()
        
        
    }
    
    func updateEntry(title: String, entryBodyText: String, mood: String, entry: Entry){
        entry.title = title
        entry.bodyText = entryBodyText
        entry.timeStamp = Date()
        entry.mood = mood
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry){
        deleteEntryFromServer(entry: entry)
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
}
