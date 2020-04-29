//
//  EntryController.swift
//  Journal
//
//  Created by Claudia Contreras on 4/28/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    // MARK: - Properties
    let baseURL = URL(string: "https://journal-23243.firebaseio.com/")!
    
    // MARK: - Functions
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        //Take the baseURL and append the identifier of the entry parameter to it. Add the "json" extension to the URL as well.
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        //Create a URLRequest object. Set its HTTP method to PUT.
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        //Using JSONEncoder, encode the entry's entryRepresentation into JSON data. Set the URL request's httpBody to this data.
        do {
            guard let entryRepresentation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            NSLog("Error encoding task \(entry): \(error)")
            completion(.failure(.noEncode))
        }
        
        //Perform a URLSessionDataTask with the request, and handle any errors. Make sure to call completion and resume the data task.
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error Puting task to server: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier ))
            return
        }
        
        // Create a URL from the baseURL and append the entry parameter's identifier to it. Also append the "json" extension to the URL as well. This URL should be formatted the same as the URL you would use to PUT an entry to Firebase.
        let requestURL = baseURL.appendingPathExtension(identifier).appendingPathExtension("json")
        
        // Create a URLRequest object, and set its HTTP method to DELETE.
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        // Perform a URLSessionDataTask with the request and handle any errors. Call completion and don't forget to resume the data task.
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting task in server: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.mood = entryRepresentation.mood
        entry.timestamp = entryRepresentation.timestamp
    }
    
    func updateEntries(with representations: [EntryRepresentation]) throws {
        let identifiersToFetch = representations.compactMap({ $0.identifier })
        
        // Create a fetch request from Entry object.
        let fetchRequest: NSFetchRequest<Entry>  = Entry.fetchRequest()
        
        // Create a dictionary with the identifiers of the representations as the keys, and the values as the representations. To accomplish making this dictionary you will need to create a separate array of just the entry representations identifiers. You can use the zip method to combine two arrays of items together into a dictionary.
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        // copy of of the representationsByID for later use
        var entriesToCreate = representationsByID
        
        // Give the fetch request an NSPredicate. This predicate should see if the identifier attribute in the Entry is in identifiers array that you made from the previous step. Refer to the hint below if you need help with the predicate.
        let predicate = NSPredicate(format: "identifier in %@", identifiersToFetch)
        fetchRequest.predicate = predicate

        // Perform the fetch request on your core data stack's mainContext. This will return an array of Entry objects whose identifier was in the array you passed in to the predicate. Make sure you handle a potential error from the fetch method on your managed object context, as it is a throwing method.
        let context = CoreDataStack.shared.mainContext
        
        do {
            
            let existingEntries = try context.fetch(fetchRequest)
            
            // From here, loop through the fetched entries and call your update(entry: ... method that you made earlier. One you have updated the entry, remove the entry from the dictionary you made a few points earlier. This will make it so you only create entries from the remaining objects in the dictionary. The only ones that would remain after this loop are ones that didn't exist in Core Data already.
            for entry in existingEntries {
                guard let id = entry.identifier,
                    let representation = representationsByID[id] else { continue }
                
                entry.title = representation.title
                entry.bodyText = representation.bodyText
                entry.mood = representation.mood
                entry.timestamp = representation.timestamp
                
                entriesToCreate.removeValue(forKey: id)
            }
            
             // Then make a second loop through your dictionary's values property. This should create an entry for each of the values in that dictionary using the Entry initializer that takes in an EntryRepresentation and an NSManagedObjectContext
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
            
        } catch {
            NSLog("Error fetching tasks for Identifier: \(error)")
        }
        
        //  Under both loops, call saveToPersistentStore() to persist the changes and effectively synchronize the data in the device's persistent store with the data on the server. Since you are using an NSFetchedResultsController, as soon as you save the managed object context, the fetched results controller will observe those changes and automatically update the table view with the updated entries.
        try self.saveToPersistentStore()
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        // Take the baseURL and add the "json" extension to it.
        let requestURL = baseURL.appendingPathExtension("json")
        
        // Perform a GET URLSessionDataTask with the url you just set up.
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            // In the completion of the data task, check for errors
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            
            // Unwrap the data returned in the closure.
            guard let data = data else {
                NSLog("Error: No data returned from data task")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            // Create a variable of type [EntryRepresentation]. Set its initial value to an empty array.
            var entryRepresentations: [EntryRepresentation] = []
            
            // Decode the data into [String: EntryRepresentation].self. Set the value of the array you just made in the previous step to the entry representations in this decoded dictionary. Think about why we are decoding it in this way. Loop through the dictionary to return an array of just the entry representations without the identifier keys. HINT: You can use a for-in loop or map to do this.
            do {
                entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                
                // Call your updateEntries method that you just made in the previous step.
                try self.updateEntries(with: entryRepresentations)
                
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                // Call completion and pass in nil for the error.
                NSLog("Error decoding task representations: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
            }
        }.resume()
        // Don't forget to resume the data task.
        
    }
    
    func saveToPersistentStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
}

