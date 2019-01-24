//
//  EntryController.swift
//  Journal: Core Data
//
//  Created by Ivan Caldwell on 1/22/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    typealias CompletionHandler = (Error?) -> Void
    private let baseURL = URL(string: "https://core-data-journal-69f40.firebaseio.com/")!
    
    init() {
        fetchEntriesFromServer()
    }
    
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        var uuid = entry.identifier
        if uuid == nil {
            uuid = UUID().uuidString
            entry.identifier = uuid
            self.saveToPersistentStore()
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid!).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            let body = try JSONEncoder().encode(entry)
            request.httpBody = body
        } catch {
            NSLog("\nError encoding journal entry:\n \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("\nError saving journal entry:\n \(error)")
            }
            completion(error)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completionHandler: @escaping CompletionHandler) {
        let requestURL = baseURL.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("\nError deleting journal entry:\n \(error)")
            }
            completionHandler(error)
            }.resume()
    }
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.timestamp = entryRepresentation.timestamp
        entry.mood = entryRepresentation.mood
    }
    
    
    
    func fetchSingleEntryFromPersistentStore(identifier: String) -> Entry? {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = predicate
        let mainContext = CoreDataStack.shared.mainContext
        let entry = try? mainContext.fetch(fetchRequest)
       
        // Could use a guard statement to check for nil? Maybe nahhhhhhh...
        return entry?.first
    }
        
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching journal entries: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from the data task.")
                completion(NSError())
                return
            }
            
            DispatchQueue.main.async {
                do {
                    var entryRepresentations: [EntryRepresentation] = []
                    entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map({$0.value})
                    
                    for entryRepresentation in entryRepresentations {
                        guard let identifier = entryRepresentation.identifier else { continue }
                        
                        
                        if let entry = self.fetchSingleEntryFromPersistentStore(identifier: identifier), entry != entryRepresentation {
                            self.update(entry: entry, entryRepresentation: entryRepresentation)
                        } else {
                            _ = Entry(entryRepresentation: entryRepresentation)
                        }
                    }
                    
                    self.saveToPersistentStore()
                    completion(nil)
                    
                } catch {
                    print("\nEntryController:\nError performing dataTask in fetchEntriesFromServer \(error)")
                }
            }
            }.resume()
    }
        
        
    func saveToPersistentStore(){
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Unable to save.\n EntryController Line: \(error)")
        }
    }
    /*
     Delete or comment out the loadFromPersistentStore method, and the entries array in the EntryController
     func loadFromPersistentStore() -> [Entry] {
     do {
     let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
     let entries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
     return entries
     } catch {
     fatalError("EntryController: Could not fetch entries. \n\(error)")
     }
     }
     
     var entries: [Entry] {
     // This will allow any changes to the persistent store become immediately
     // visible to the user when accessing this array
     let journalEntries = loadFromPersistentStore()
     return journalEntries
     }
     */
    
    func create(title: String, bodyText: String, mood: String) {
        let newEntry = Entry(context: CoreDataStack.shared.mainContext)
        newEntry.title = title
        newEntry.bodyText = bodyText
        newEntry.timestamp = Date()
        newEntry.identifier = UUID().uuidString
        newEntry.mood = mood
        put(entry: newEntry) { (_) in}
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String?, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        put(entry: entry) { (_) in}
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        deleteEntryFromServer(entry: entry) { (_) in}
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
}
