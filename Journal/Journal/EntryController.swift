//
//  EntryController.swift
//  Journal
//
//  Created by Ufuk Türközü on 27.01.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case put = "PUT"
    case delete = "DELETE"
}

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
//    var entries: [Entry] {
//       loadFromPersistentStore()
//    }
//
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let context = CoreDataStack.shared.mainContext
//            do {
//                return try context.fetch(fetchRequest)
//            } catch {
//                NSLog("Error fetching data: \(error)")
//                return []
//            }
//    }
    
let baseURL = URL(string: "https://journalfirebase-adb69.firebaseio.com/")!
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        guard let identifier = entry.identifier else { return }
        entry.identifier = identifier
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let entryRepresentation = entry.entryRepresentation else {
            NSLog("Entry Representation is nil")
            completion(nil)
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            NSLog("Error encoding entry representation")
            DispatchQueue.main.async {
                completion(error)
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) {_, _, error in
            if let error = error {
                NSLog("Error putting task: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    func fetchEntriesFromServer(completion: @escaping() -> Void = { }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                DispatchQueue.main.async {
                        completion()
                    }
                    return
                }
                
            guard let data = data else {
                NSLog("No data returned from data task")
                completion()
                return
            }
            
            do {
                let entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                self.updateEntries(representations: entryRepresentations)
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                NSLog("Error decoding task representations: \(error)")
                DispatchQueue.main.async {
                    completion()
                }
            }
        }.resume()
    }
    
    @discardableResult func createEntry(with title: String, timestamp: Date, bodyText: String, mood: EntryMood) -> Entry {
        
        let entry = Entry(title: title, timestamp: timestamp, bodyText: bodyText, mood: mood, context: CoreDataStack.shared.mainContext)
        
        put(entry: entry)
        CoreDataStack.shared.save()
        
        return entry
    }
    
    func updateEntry(entry: Entry, with title: String, timestamp: Date, bodyText: String, mood: EntryMood) -> Entry {
        
        entry.title = title
        entry.timestamp = Date()
        entry.bodyText = bodyText
        //entry.identifier = identifier
        entry.mood = mood.rawValue
        
        put(entry: entry)
        CoreDataStack.shared.save()
        
        return entry
    }
    
    func delete(entry: Entry) {
        
        CoreDataStack.shared.mainContext.delete(entry)
        deleteEntryFromServer(entry: entry) /*{ error in
            if let error = error {
                print("Error deleting task from server: \(error)")
                return
            }
            
            CoreDataStack.shared.mainContext.delete(entry)
            do {
                CoreDataStack.shared.save()
            } catch {
                CoreDataStack.shared.mainContext.reset()
                NSLog("Error saving managed object context: \(error)")
            }
        } */
        CoreDataStack.shared.save()
    }
    
    private func updateEntries(representations: [EntryRepresentation]) {
        let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier)})
        
        // [UUID: TaskRepresentation]
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        // Make a mutable copy of the dictionary above
        var entriesToCreate = representationsByID
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.performAndWait {
        
        do {
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
            let existingEntries = try context.fetch(fetchRequest)
            
            for entry in existingEntries {
                guard let identifier: UUID = UUID(uuidString: entry.identifier ?? UUID().uuidString),
                    // This gets the task representation that corresponds to the task from CoreData
                    let representation = representationsByID[identifier] else { continue }
                
                entry.title = representation.title
                //entry.identifier = representation.identifier
                entry.bodyText = representation.bodyText
                entry.mood = representation.mood
                entry.timestamp = representation.timestamp
                
                entriesToCreate.removeValue(forKey: identifier)
            }
           
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
            
            CoreDataStack.shared.save(context: context)
            
        } catch {
            NSLog("Error fetching tasks from persistent store: \(error)")
        }
        
    }
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        
        guard let uuid = entry.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue

        URLSession.shared.dataTask(with: request) { _, response, error in
            print(response!)
            DispatchQueue.main.async {
                completion(error)
            }
        }.resume()
    }
}
