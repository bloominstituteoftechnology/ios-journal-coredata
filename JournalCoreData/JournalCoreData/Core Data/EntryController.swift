import Foundation
import CoreData

class EntryController {
    //MARK: Firebase
    typealias CompletionHandler = (Error?) -> Void
    
    private let baseURL = URL(string: "https://journal-coredata-f20ba.firebaseio.com/")!
    
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
            // guard let representation = entry.entryRepresentation else { throw NSError() }
            
            let id = entry.identifier
            let requestURL = baseURL.appendingPathComponent(id!).appendingPathExtension("json")
            var request = URLRequest(url: requestURL)
            request.httpMethod = "DELETE"
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
