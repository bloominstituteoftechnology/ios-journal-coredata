//
//  EntryController.swift
//  Journal - Day 2
//
//  Created by Sameera Roussi on 6/2/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

// Steps 1-6 are pulling from the server
// Step 7 is saving to the server
// Step 8 is deleting from the server.  Be sure to change the delete in the EntriesTableViewController to call it!

import Foundation
import CoreData

// let baseURL = URL(string: "https://myjournal-9a0a7.firebaseio.com/")!

class EntryController {
    
    typealias CompletionHandler = (Error?) -> Void  // Step 1
        // Need a method to save information to the server
        // Need a method to get information from the server
    
    // Need to know the location of the server we will be talking to
     private let baseURL = URL(string: "https://myjournal-1080b.firebaseio.com/")!   // Step 2
    
    // The first time we create a task controllers we want it to
    init() {
        fetchEntriesFromServer()  // When we start we want the first step to be a fetch.
    }
    
    // Method to get information from the server
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {  // Step 4
        // Talk to Firebase
        let requestURL = baseURL.appendingPathExtension("json")
        
        // Talk to Firebase
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            // Check for errors
            if let error = error {
                print("error fetching tasks: \(error)")
                completion(error)
                return
            }
            
            // Check for data
            guard let data = data else {
                print("No data returned from the data task")
                completion(NSError())
                return
            }
            
            // The data request must happen on the main queue:
            DispatchQueue.main.async {
                // We have data and no errors
                // We need to decode  it into an array of [EntryRepresentations]
                // We need to import the Representations into CoreData
                // We need to save the changes
                // Since decoding and saving may throw erros we will do them in a do - try - catch block:
                do {
                    // Firebase returns data in an array of  Dictionary.  We only want the values, not the keys
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode([String: EntryRepresentation].self, from: data)       // Step 5
                    // Get the values from the decoded data and store them into an array
                    let entryRepresentations = Array(decodedResponse.values)
                    try self.importEntryRepresentations(entryRepresentations)   // This is defined in step 6
                    completion(nil)  // There were no errors in step 5
                } catch {
                    print("Error inporting entry data: \(error)")
                    completion(error)
                }
            }
            
        } .resume()
    }
    
    // Step 6 - Importing all of our a tasks
    // We have the data, still as a Representation.  Now it's time to check for the exsistance of these entries in locall persistence.
     // We need to import the Representations into CoreData.
    // Putting it into a separate function just to keep things clean
    private func importEntryRepresentations(_ entryRepresentations: [EntryRepresentation]) throws {  // Will throw if it fails
        // Import the task representations
        // try to save our changes
        // We will have to iterate them one by one
        
        let moc = CoreDataStack.shared.mainContext
        
        for entryRepresentation in entryRepresentations {
            // We have to watch for two things: 1.. If it is already in persistent storage in storage already.
            // If we have an entry with the UUID already (on both the server and persistent storage), make sure they are the same  or it has been updated.
            if let existingEntry = entry(with: entryRepresentation.identifier) {
                // It's on the server so update it with what is on Firebase
                existingEntry.title = entryRepresentation.title
                existingEntry.bodyText = entryRepresentation.bodyText
                existingEntry.timestamp = entryRepresentation.timestamp
                existingEntry.mood = entryRepresentation.mood
            } else {
                // If we didn't find the entry create a new entry
               _ = Entry(entryRepresentation: entryRepresentation, context: moc)
            }
        }
        
        try moc.save()    // We go back up to step 4 which is where we called this.
    }
    
    // Step 6.1
    // Create another separate function to do the actual looking up for the UUID.
    private func entry(with identifier: UUID) -> Entry?  {   // This should return an option because the entry may not exsist
        // Create a fetch request with a predicate to find the UUID
        let predicate = NSPredicate(format: "identifier == %@", identifier as NSUUID)  // Attach a predicate to the fetch request to search for the entry with the specified UUID
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = predicate
        // Let's try to fetch (find the UUID) on persisted store
        // Must be done in a context
        let moc = CoreDataStack.shared.mainContext
        let matchingEntry = try? moc.fetch(fetchRequest)  // Fetch requests return arrays
        
        // Return the first entry with UUID that the fetech found, or nothing if it didn't find it (that's why matchingEntry is matchingEntry?
        // fetch requ
        return matchingEntry?.first
    }
    
    
    // Step 7
    // This functioin saves my entries to Firebase (@1:30 in video)
    // We must save whenever we create or modify an entry
    func put(entry: Entry, completion: @escaping CompletionHandler = {  _ in }) {
        // 1. Turn the CoreData Task into a TaskRepresentation
        // 2. Send the entry representation to the server
        
        do {
            // Make sure we can get an entry representation from the entry
            guard let representation = entry.entryRepresentation else { throw NSError() }  // In the real world we actually would provide more information in the error message

            // Make sure we have a UUID
            let uuid = entry.identifier ?? UUID()
           
            let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
            var request = URLRequest(url: requestURL)
            
            // Since we are saving data we need to use the HTTP PUT method
            request.httpMethod = "PUT"
            
            // Now we need to create the data to be saved.  It goes into the HTTP body of the request.
            //  We get it when we encode the data as JSON
            request.httpBody = try JSONEncoder().encode(representation)
            
            //Create the URLSession to execute the request
            URLSession.shared.dataTask(with: request) { (_, _, error) in
                if let error = error {
                    print("Error PUTting journal entry to server: \(error)")
                }
                completion(error)
            } .resume()
            
        } catch {
            print("Error attempting to PUT entry: \(error)")
            completion(error)
        }
        
    }
    
    // Step 8
    func deleteFromServer(_ entry: Entry, completion: @escaping ((Error?) -> Void) = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(NSError())
            return
        }
    
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response!)
            completion(error)
        }.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Persistent save
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Unable to save to Persistent data file \(error)")
        }
    }
    
    // MARK: - CRUD functions
    
    // Crud
    func createEntry(title: String, bodyText: String, mood: Mood) {
        _ = Entry(title: title, bodyText: bodyText, mood: mood.rawValue)
        saveToPersistentStore()
    }
    
    // crUd
    func update(entry: Entry, title: String, bodyText: String, mood: Mood) {
        entry.setValue(title, forKey: "title")
        entry.setValue(bodyText, forKey: "bodyText")
        entry.setValue(mood.rawValue, forKey: "mood")
        entry.setValue(Date(), forKey: "timestamp")
        saveToPersistentStore()
    }
    
    //cruD
    func delete(delete: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(delete)
        saveToPersistentStore()
    }
    
    // MARK: - Properties
    let encoder = JSONEncoder()
    
    
}  // Class
