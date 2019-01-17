import Foundation
import CoreData

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    //MARK: Firebase
    typealias CompletionHandler = (Error?) -> Void
    
    private let baseURL = URL(string: "https://journal-coredata-f20ba.firebaseio.com/")!
    let moc = CoreDataStack.shared.mainContext
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }){
        
        do {
           // guard let representation = entry.entryRepresentation else { throw NSError() }
            
            let id = entry.identifier
            let requestURL = baseURL.appendingPathComponent(id!).appendingPathExtension("json")
            var request = URLRequest(url: requestURL)
            request.httpMethod = "PUT"
            request.httpBody = try JSONEncoder().encode(entry)
            URLSession.shared.dataTask(with: request) { (_, _, error) in
                if let error = error {
                    print("error putting task: \(error)")
                }
                completion(error)
                }.resume()
            
        }catch {
            print("error saving task: \(error)")
            completion(error)
        }
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }){
        
        do {
            //guard let representation = entry.entryRepresentation else { throw NSError() }
            
            let id = entry.identifier
            let requestURL = baseURL.appendingPathComponent(id!).appendingPathExtension("json")
            var request = URLRequest(url: requestURL)
            request.httpMethod = "DELETE"
            request.httpBody = try JSONEncoder().encode(entry)
            URLSession.shared.dataTask(with: request) { (_, _, error) in
                if let error = error {
                    print("error deleting task: \(error)")
                }
                completion(error)
                }.resume()
            
        }catch {
            print("error saving task: \(error)")
            completion(error)
        }
    }
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation){
        entry.bodyText = entryRepresentation.bodyText
        entry.title = entryRepresentation.title
        entry.timeStamp = entryRepresentation.timeStamp
        entry.identifier = entryRepresentation.identifier
        entry.mood = entryRepresentation.mood
    }
    
    func fetchSingleEntryFromPersistentStore(with identifier: String) -> Entry? {
        
        let predicate = NSPredicate(format: "identifier == %@", identifier as String)
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = predicate
        let matchingEntries = try? moc.fetch(fetchRequest)
        
        return matchingEntries?.first
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
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode([String: EntryRepresentation].self, from: data)
                    let entryRepresentations = Array(decodedResponse.values)
                    try self.importEntryRepresentations(entryRepresentations)
                    completionHandler(nil)
                    
                }catch {
                    print("error importing entries: \(error)")
                    completionHandler(error)
                }
            }
        }.resume()
    }
    
    func importEntryRepresentations(_ entryRepresentations: [EntryRepresentation]) throws {
        //FIXME: add logic for sync.
        for entryRepresentation in entryRepresentations {
            if let existingEntry = fetchSingleEntryFromPersistentStore(with: entryRepresentation.identifier!){
                existingEntry.bodyText = entryRepresentation.bodyText
                existingEntry.mood = entryRepresentation.mood
                existingEntry.timeStamp = entryRepresentation.timeStamp
                existingEntry.title = entryRepresentation.title
            }else{
               _ = Entry(entryRepresentation: entryRepresentation, moc: moc)
                
            }
        }
        saveToPersistentStore()
        //try moc.save()
    }
    

    func saveToPersistentStore(){
        // save data to mainContext
        do {
            try CoreDataStack.shared.mainContext.save()
        }catch {
            print("failed to save: \(error)")
        }
    }
    
//    func loadFromPersistentStore() -> [Entry]{
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let results = (try? CoreDataStack.shared.mainContext.fetch(fetchRequest)) ?? []
//        print(results)
//        return results
//    }
//    
//    var entries: [Entry]? {
//        return loadFromPersistentStore()
//        
//    }
    
    func createEntry(title: String, entryBody: String?, mood: String){
        print("did we make it to the create func?") // FIXME: never even getting here
        let newEntry = Entry(title: title, bodyText: entryBody ?? "", identifier: UUID().uuidString, mood: mood, context: CoreDataStack.shared.mainContext)
        
        print("this should be creating a new entry.")
        put(entry: newEntry)
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
