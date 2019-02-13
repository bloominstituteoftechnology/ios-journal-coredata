//  Copyright © 2019 Frulwinn. All rights reserved.

import Foundation
import CoreData

class EntryController {
    
    let baseURL = URL(string: "https://test-82e39.firebaseio.com/")!
    
    //MARK: - Properties

    
    func saveToPersistentStore() {
        //save core data stack's mainContext, bundle the changes
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func create(title: String, bodyText: String, mood: JournalMood) {
        Entry(title: title, bodyText: bodyText, mood: mood)
        
        saveToPersistentStore()
        put(entry)
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        
        saveToPersistentStore()
        put(entry)
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
       
        saveToPersistentStore()
    }
    
    func put(_ entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        let identifier = entry.identifier ?? UUID()
        
        let url = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        //entry ->entry representation -> json data
        guard let entryRepresentation = entry.entryRepresentation else {
            NSLog("Unable to convert task to ask representation")
            completion(NSError())
            return
        }
        
        let encoder = JSONEncoder()
        
        do {
            let taskJSON = try encoder.encode(entryRepresentation)
            
            request.httpBody = taskJSON
        } catch {
            NSLog("unable to encode task representation: \(error)")
            completion(error)
        }
                
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting task to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
}
