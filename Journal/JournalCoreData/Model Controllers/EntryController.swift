//
//  EntryController.swift
//  JournalCoreData
//
//  Created by Spencer Curtis on 8/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-96aa9.firebaseio.com/")!

class EntryController {
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchTasksFromServer()
    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        // Told it what endpoint or URL to send it to and constructed the URL
        let identifier = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(entry.entryRepresentation)
        } catch {
            NSLog("Error encoding Entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching entries: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
        }.resume()
    }
    
//    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
//        let uuid = entry.identifier ?? UUID().uuidString
//        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
//        var request = URLRequest(url: requestURL)
//        request.httpMethod = "PUT"
//        
//        do {
//            var representation = entry.entryRepresentation else {
//                completion(NSError())
//                return
//            }
//            representation.identifier = uuid
//            entry.identifier = uuid
//            try CoreDataStack.shared.save()
//            request.httpBody = try JSONEncoder().encode(representation)
//        } catch {
//            print("Error encoding task: \(error.localizedDescription)")
//            completion(error)
//            return
//        }
//        
//        URLSession.shared.dataTask(with: request) { data, _, error in
//            if let error = error {
//                print("Error PUTting task to server: \(error)")
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//                return
//            }
//            
//            DispatchQueue.main.async {
//                completion(nil)
//            }
//        }.resume()
//    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard  let uuid = entry.identifier else {
            completion(NSError())
            return
            
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            print(response)
            DispatchQueue.main.async {
                completion(error)
            }
        }.resume()
    }
    
    private func updateEntries(with representations: [EntryRepresentation]) throws {
        let entriesWithID = representations.filter { $0.identifier != nil }
        let identifiersToFetch = entriesWithID.compactMap ({UUID(uuidString:$0.identifier!) })
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.perform {
            
            do {
                let existingEntries = try context.fetch(fetchRequest)
                
                for entry in existingEntries {
                    guard let id = entry.identifier,
                        let identifier = UUID(uuidString: id),
                        let representation = representationsByID[identifier] else { continue }
                    self.update(entry: entry, with: representation)
                    entriesToCreate.removeValue(forKey: identifier)
                }
                
                for representation in entriesToCreate.values {
                    Entry(entryRepresentation: representation, context: context)
                }
            } catch {
                print("Error fetching tasks for UUIDs: \(error)")
            }
        }
        
        try CoreDataStack.shared.save(context: context)
    }
    
    func fetchTasksFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                print("Error fetching entries: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else {
                print("No data returned by data entry")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            do {
                let entryRepresentation = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                try self.updateEntries(with: entryRepresentation)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding entry representation: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
        }.resume()
    }
    
    
    
    func createEntry(with title: String, bodyText: String, mood: String) {
        
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        
        put(entry: entry)
    }
    
    
    func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
        entry.identifier = representation.identifier
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        
        // Save to persistent store
    }
    
//    func delete(entry: Entry) {
//
//        deleteEntryFromServer(entry: entry)
//        CoreDataStack.shared.mainContext.delete(entry)
//
//        do {
//            try self.saveToPersistentStore()
//        } catch {
//            print("Some error message here:")
//        }
//    }
    
}


