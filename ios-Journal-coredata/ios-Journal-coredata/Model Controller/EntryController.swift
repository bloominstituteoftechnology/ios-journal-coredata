//
//  EntryController.swift
//  ios-Journal-coredata
//
//  Created by Jonalynn Masters on 10/15/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    let baseURL = URL(string: "https://journal-5b2fb.firebaseio.com/")!

    init() {
        fetchEntryFromServer()
    }
    
    func fetchEntryFromServer(completion: @escaping () -> Void = {} ) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        URLSession.shared.dataTask(with: request) {(data, _, error) in
            
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from entry fetch data task")
                completion()
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let entries = try decoder.decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                self.createEntries(with: entries)
                
            } catch {
                NSLog("Error decoding Entry Representation: \(error)")
            }
            completion()
        }.resume()
    }
    
    func createEntries(with representations: [EntryRepresentation]) {
        // Which representations do we already have in Core Data?
        
        let identifiersToFetch = representations.map({ $0.identifier })
        
        // [UUID: TaskRepresentation]
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        // Make a mutable copy of the dictionary above
        
        var entriesToCreate = representationsByID
        
        do {
            let context = CoreDataStack.shared.mainContext
            
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            
            // Only fetch the tasks with the identifiers that are in this identifier
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
            
            let existingEntries = try context.fetch(fetchRequest)
            
            // Update the ones we do have
            
            for entry in existingEntries {
                
                // Grab the TaskRepresentation that corresponds to this Task
                
                guard let identifier = entry.identifier,
                    let representation = representationsByID[identifier] else { continue }
                
                entry.title = representation.title
                entry.bodyText = representation.bodyText
                entry.timestamp = representation.timestamp
                entry.mood = representation.mood
                
                // We just updated a task, we don't need to create a new Task for this identifier
                entriesToCreate.removeValue(forKey: identifier)
                
            }
            
            // Figure out which ones we don't have
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
                
            }
            // Persist all the changes (updating and creating of tasks) to Core Data
            CoreDataStack.shared.saveToPersistentStore()
        } catch {
            NSLog("Error fetching entries from persistent store: \(error)")
        }
                
    }
    
    // MARK: Put task to firebase
       enum HTTPMethod: String {
           case get = "GET"
           case put = "PUT"
           case post = "POST"
           case delete = "DELETE"
       }
       
       func put(entry: Entry, completion: @escaping () -> Void = {} ) {
           

           let identifier = entry.identifier ?? UUID()
           entry.identifier = identifier
           
           let requestURL = baseURL
               .appendingPathComponent(identifier.uuidString)
               .appendingPathExtension("json")
           
           var request = URLRequest(url: requestURL)
           request.httpMethod = HTTPMethod.put.rawValue
           
        guard let entryRepresentation = entry.entryRepresentation else {
               NSLog("Entry Representation is nil")
               completion()
               return
           }
           
           do {
               request.httpBody = try JSONEncoder().encode(entryRepresentation)
           } catch {
               NSLog("Error encoding entry representation: \(error)")
               completion()
               return
           }
           
           URLSession.shared.dataTask(with: request) { (_, _, error) in
               
               if let error = error {
                   NSLog("Error PUTting task: \(error)")
                   completion()
                   return
               }
               
               completion()
           }.resume()
       }
  
    // MARK: CRUD
    
    // Create Entry
    func createEntry(with title: String, bodyText: String, mood: Mood, context: NSManagedObjectContext) {
        
        let entry = Entry(title: title, bodyText: bodyText, mood: mood, context: context)
        CoreDataStack.shared.saveToPersistentStore()
        put(entry: entry)
    }
    // Update Entry
    func updateEntry(entry: Entry, with title: String, bodyText: String, mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        CoreDataStack.shared.saveToPersistentStore()
        put(entry: entry)
    }
    // Delete Entry
    func deleteEntry(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        CoreDataStack.shared.saveToPersistentStore()
    }
}



