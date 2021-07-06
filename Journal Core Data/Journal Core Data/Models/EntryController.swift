//
//  EntryController.swift
//  Journal Core Data
//
//  Created by Bhawnish Kumar on 3/23/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//
//import Foundation
//import CoreData
//

//class EntryController {
//
//    typealias CompletionHandler = (Error?) -> Void
//
//    init() {
//        fetchEntriesFromServer()
//    }
//

//}



import Foundation
import CoreData
class EntryController {
    
    let baseURL = URL(string: "https://journal-core-data-bc6cd.firebaseio.com/")
    
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchEntriesFromServer()
    }
    
    func saveToPersistentStore() {
        
        do {
            try CoreDataStack.shared.mainContext.save() // has to see with books array.
            
        } catch {
            NSLog("error saving managed obejct context: \(error)")
        }
    }
    
    
    func createEntry(identifier: UUID, title: String, bodyText: String, timeStamp: Date, mood: String) -> Entry {
        
        let newEntry = Entry(identifier: UUID(), title: title, bodyText: bodyText, timeStamp: timeStamp, mood: mood, context: CoreDataStack.shared.mainContext)
        return newEntry
    }
    
    func updateEntry(entryTitle: String, bodyText: String, entry: Entry, mood: String) {
        entry.title = entryTitle
        entry.bodyText = bodyText
        entry.timeStamp = Date()
        entry.mood = mood
        saveToPersistentStore()
       
    }
    
    func deleteEntry(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    func put(entry: EntryRepresentation, completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL?.appendingPathComponent(entry.identifier).appendingPathExtension("json")
        guard let newRequestURL = requestURL else { return }
        var request = URLRequest(url: newRequestURL)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let json = try JSONEncoder().encode(entry)
            request.httpBody = json
        } catch {
            NSLog("Error Encoding json from entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Network error putting entry: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                // we have a successful response
                completion(nil)
            }
            
        }.resume()
        
    }
    func deleteEntryFromServer(entry: EntryRepresentation, completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL?.appendingPathComponent(entry.identifier).appendingPathExtension("json")
        
        guard let newRequestURL = requestURL else { return }
        var request = URLRequest(url: newRequestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Network error putting entry: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                // we have a successful response
                completion(nil)
            }
            
        }.resume()
        
        
        
            
    }
  func updateEntries(with representations: [EntryRepresentation]) {
           let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
           
           let entriesWithID = representations.filter { $0.identifier != nil }
           let identifiersToFetch = entriesWithID.compactMap { $0.identifier }
           let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
           var entriesToCreate = representationsByID
           
           fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
           do {
               let existingEntries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
               
               // match the managed entries with the firebase entries
               for entry in existingEntries {
                   guard let id = entry.identifier, let representation = representationsByID[id] else { continue }
                   self.update(entry: entry, entryRepresentation: representation)
                   entriesToCreate.removeValue(forKey: id)
               }
               
               for representation in entriesToCreate.values {
                   Entry(entryRepresentation: representation)
               }
               
               saveToPersistentStore()
               
           } catch {
               NSLog("Error fetching entries for UUIS's: \(error)")
           }
           
       }
    
    func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title  = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timeStamp = representation.timestamp
        entry.identifier = representation.identifier
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL?.appendingPathExtension("json")
       
        guard let newRequestURL = requestURL else { return }
        var request = URLRequest(url: newRequestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error fetching entires from firebase: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Error with data from firebase:")
                completion(NSError())
                return
            }
            
            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
                
                self.updateEntries(with: entryRepresentations)
                
                completion(nil)
                
            } catch {
                NSLog("Error decoding entry representations from firebase: \(error)")
                completion(error)
            }
        }.resume()
        
    }
    
}
