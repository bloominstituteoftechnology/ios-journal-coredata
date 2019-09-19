//
//  EntryController.swift
//  Journal-CoreData
//
//  Created by Ciara Beitel on 9/16/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    let baseURL = URL(string: "https://journal-coredata-day3-46514.firebaseio.com/")!
    
    func put(entry: Entry, completion: @escaping () -> Void = { }) {
        
        let identifier = entry.identifier ?? UUID()
        entry.identifier = identifier
        
        // Take the baseURL and append the identifier of the entry parameter to it. (unwrap identifier first)
        // Add the "json" extension to the URL as well.
        let requestURL = baseURL
        .appendingPathComponent(identifier.uuidString)
        .appendingPathExtension("json")
        
        // Create a URLRequest object. Set its HTTP method to PUT.
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue // add 'enum HTTPMethod' at top of page
        
        // Unwrap entryRepresentation first.
        guard let entryRepresentation = entry.entryRepresentation else {
            NSLog("Entry Representation is nil")
            completion()
            return
        }
        
        // Using JSONEncoder, encode the entry's entryRepresentation into JSON data.
        // Set the URL request's httpBody to this data.
        do {
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            NSLog("Error encoding entry representation: \(error)")
            completion()
            return
        }
        
        // Perform a URLSessionDataTask with the request, and handle any errors.
        // Make sure to call completion and resume the data task.
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            // Handle errors
            if let error = error {
                NSLog("Error PUTting task: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func fetchEntriesFromServer(completion: @escaping () -> Void = { }) { // ⚠️ { Error } ??? completion(nil) ???
        
        // Take the baseURL and add the "json" extension to it.
        let requestURL = baseURL.appendingPathExtension("json")
        
        // Create a variable of type [EntryRepresentation]. Set its initial value to an empty array
        var entryRepresentations: [EntryRepresentation] = []
        
        // Perform a GET URLSessionDataTask with the url you just set up
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            // In the completion of the data task, check for errors
            if let error = error {
                NSLog("Error fetching from server: \(error)")
                completion()
                return
            }
            
            // Unwrap the data returned in the closure
            guard let data = data else {
                NSLog("No data returned from data task")
                completion()
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                // Decode the data into [String: EntryRepresentation].self
                // Set the value of the array you just made in the previous step to the entry representations in this decoded dictionary
                // Loop through the dictionary to return an array of just the entry representations without the identifier keys, you can use map to do this.
                entryRepresentations = try decoder.decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                
                // Call your updateEntries method that you just made in the previous step
                self.updateEntries(with: entryRepresentations)
                
            } catch {
                NSLog("Error decoding: \(error)")
            }
            // Call completion and pass in nil for the error??? ⚠️, Don't forget to resume the data task.
            completion()
        }.resume()
    }
    
    func update(entry: Entry, representation: EntryRepresentation) {
        entry.bodyText = representation.bodyText
        entry.identifier = representation.identifier
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
        entry.title = representation.title
    }
    
    func updateEntries(with representations: [EntryRepresentation]) {
        
        do {
        
            // Create a fetch request from Entry object
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            
            // To accomplish making this dictionary you will need to create a separate array of just the entry representations identifiers.
            let entryRepresentations = representations.compactMap({ UUID(uuidString: $0.identifier.uuidString) })
            
            //Create a dictionary with the identifiers
            var representationsByID = Dictionary(uniqueKeysWithValues: zip(entryRepresentations, representations))
                        // You can use the zip method to combine two arrays of items together into a dictionary.
            
            // Give the fetch request an NSPredicate
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", entryRepresentations)
            
            // Perform the fetch request on your core data stack's mainContext
            let context = CoreDataStack.shared.mainContext
            let existingEntries = try context.fetch(fetchRequest)
            
            // loop through the fetched entries and call your update(entry: ... method
            for entry in existingEntries {
                guard let identifier = entry.identifier,
                    let representation = representationsByID[identifier] else { continue }
                
                entry.mood = representation.mood
                entry.bodyText = representation.bodyText
                entry.title = representation.title
                entry.timestamp = representation.timestamp
                
                // remove the entry from the dictionary
                representationsByID.removeValue(forKey: identifier)
            }
            
            // make a second loop through your dictionary's values property
            // This should create an entry for each of the values in that dictionary using the Entry initializer that takes in an EntryRepresentation and an NSManagedObjectContext
            for representation in representationsByID.values {
                Entry(entryRep: representation, context: context)
            }
            
            // Make sure you handle a potential error from the fetch method on your managed object context
            } catch {
                NSLog("Error fetching entries \(error)")
            }
        
        // Under both loops, call saveToPersistentStore() to persist the changes and effectively synchronize the data in the device's persistent store with the data on the server
        saveToPersistentStore()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping () -> Void = { }) {
        
        let identifier = entry.identifier ?? UUID()
        
        let requestURL = baseURL
            .appendingPathComponent(identifier.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            // Handle errors
            if let error = error {
                NSLog("Error deleting entry: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
            CoreDataStack.shared.mainContext.reset()
        }
    }
    
    func createEntry(title: String, bodyText: String, timestamp: Date, identifier: UUID, mood: String) -> Entry {
        let entry = Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, mood: mood, context: CoreDataStack.shared.mainContext)
        saveToPersistentStore()
        put(entry: entry)
        return entry
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func deleteEntry(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        deleteEntryFromServer(entry: entry)
        saveToPersistentStore()
    }
}
