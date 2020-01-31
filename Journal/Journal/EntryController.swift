//
//  EntryController.swift
//  Journal
//
//  Created by Jorge Alvarez on 1/27/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-f843e.firebaseio.com/")!

class EntryController {
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchEntriesFromServer()
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json") // + /json ?
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error fetching tasks: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else {
                print("No data returned by data task")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
                try self.updateEntries(with: entryRepresentations)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding or storing task representations: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
            
        }.resume()
    }
    
    // convert to Core Data obj
    private func updateEntries(with representations: [EntryRepresentation]) throws {
        // filter out the no ID ones
        let tasksWithID = representations.filter { $0.identifier != nil }
        
        // creates a new UUID based on the identifier of the task we're looking at (and it exists)
        // compactMap returns an array after it transforms
        let identifiersToFetch = tasksWithID.compactMap { $0.identifier!}
        
        // zip interweaves elements
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, tasksWithID))
        
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        // Create private queue context
        // Used to say let context = CoreDataStack.shared.mainContext
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.perform {
            do {
                let existingEntries = try context.fetch(fetchRequest)
                
                for entry in existingEntries {
                    // continue skips next iteration of for loop
                    guard let id = entry.identifier, let representation = representationsByID[id] else {continue}
                    self.update(entry: entry, with: representation)
                    entriesToCreate.removeValue(forKey: id)
                }
                
                for representation in entriesToCreate.values {
                    Entry(entryRepresentation: representation)
                }
            } catch {
                print("Error fetching entries for UUIDs: \(error)")
            }
        }
        
        // used to say self.saveToPersistentStore()
        try CoreDataStack.shared.save(context: context)
    }
    
    // updates local with data from the remote
    private func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp // ?
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func createEntry(title: String, bodyText: String, timestamp: Date, identifier: String, mood: Mood) {
        // ?
        let entry = Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, mood: mood)
        sendEntryToServer(entry: entry)
        saveToPersistentStore()
    }
    
    func update(title: String, bodyText: String, mood: Mood, entry: Entry) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        
        //print("UPDATED ENTRY: \(entry.title), \(entry.bodyText), \(entry.timestamp)")
        sendEntryToServer(entry: entry)
        saveToPersistentStore()
    
    }
    
    // PUT when we make new tasks. Sends to firebase
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier ?? UUID().uuidString // if it doesn't have one, make one
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT" // post ADDS to db (can add copies), "put" also finds recored and overrides it, or just adds
        
        // encode our data
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            // both version have same id
            representation.identifier = uuid
            entry.identifier = uuid
            try CoreDataStack.shared.save()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding entry \(entry): \(error)")
            DispatchQueue.main.async {
                completion(error)
            }
            return
        }
        
        // ready to be sent to the server
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            // check for error
            if let error = error {
                NSLog("error putting entry to server: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            // then it works (success)
            DispatchQueue.main.async {
                completion(nil)
            }
            
        }.resume()
    }
    
    // DELETE from server if it can, then delete locally
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        // NEEDS to have ID
        guard let uuid = entry.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json") // json type payload
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        // just for us to debug, want to if let error and if let response
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            print(response!) // 200 or error code
            
            DispatchQueue.main.async {
                completion(error)
            }
        }.resume()
    }
}
