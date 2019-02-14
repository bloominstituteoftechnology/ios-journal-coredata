//  Copyright © 2019 Frulwinn. All rights reserved.

import Foundation
import CoreData

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    let baseURL = URL(string: "https://test-82e39.firebaseio.com/")!
    
    func saveToPersistentStore() {
        //save core data stack's mainContext, bundle the changes
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    @discardableResult func create(title: String, bodyText: String, mood: JournalMood) -> Entry {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        
        saveToPersistentStore()
        put(entry)
        return entry
    }
    
    func updateWithEntryRepresentation(_ entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.mood = entryRepresentation.mood
        entry.timestamp = entryRepresentation.timestamp
        entry.identifier = entryRepresentation.identifier
        
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        
        saveToPersistentStore()
        put(entry)
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        let identifier = entry.identifier ?? UUID().uuidString
        
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        //entry ->entry representation -> json data
//        guard let entryRepresentation = entry.entryRepresentation else {
//            NSLog("Unable to convert task to ask representation")
//            completion(NSError())
//            return
//        }
        
        let encoder = JSONEncoder()
        
        do {
            let taskJSON = try encoder.encode(entry)
            
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
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        saveToPersistentStore()
        deleteEntryFromServer(entry)
    }
    
    func put(_ entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        let identifier = entry.identifier ?? UUID().uuidString
        
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        //entry ->entry representation -> json data
//        guard let entryRepresentation = entry.entryRepresentation else {
//            NSLog("Unable to convert task to ask representation")
//            completion(NSError())
//            return
//        }
        
        let encoder = JSONEncoder()
        
        do {
            let taskJSON = try encoder.encode(entry)
            
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
    
    func fetchSingleEntryFromPersistentStore(identifier: String) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            return try moc.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching task with \(identifier): \(error)")
            return nil
        }
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        
        let url = baseURL.appendingPathExtension("json")
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let entryRepresentations = try jsonDecoder.decode([String: EntryRepresentation].self, from: data)
                
                for (_, entryRep) in entryRepresentations {
                    
                    if let entry = self.fetchSingleEntryFromPersistentStore(identifier: entryRep.identifier) {
                        //let mood = JournalMood(rawValue: entryRep.mood) {
                        self.updateWithEntryRepresentation(entry, entryRepresentation: entryRep)
                        
                    } else {
                        Entry(entryRepresentation: entryRep)
                    }
                }
                
                self.saveToPersistentStore()
                
                completion(nil)
                
            } catch {
                NSLog("error decoding TaskRepresentations: \(error)")
                completion(error)
            }
        }.resume()
    }
}
