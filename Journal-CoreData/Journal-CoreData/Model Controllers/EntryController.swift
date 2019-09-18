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
