//
//  EntryController.swift
//  Journal
//
//  Created by Jake Connerly on 8/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get    = "GET"
    case put    = "PUT"
    case post   = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError(Error)
    case badData
    case noDecode
}

class EntryController {
    
    let baseURL = URL(string: "https://journal-5ee58.firebaseio.com/")!
    
    // Create
    func createEntry(with title: String, bodyText: String, timeStamp: Date, mood: Mood) {
        let entry = Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, mood: mood)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    // Update
    func updateEntry(entry: Entry, with title: String, bodyText: String, timeStamp: Date, mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = timeStamp
        entry.mood = mood.rawValue
        saveToPersistentStore()
        put(entry: entry)
    }
    
    // Delete
    func deleteEntry(entry: Entry) {
        deleteEntryFromServer(entry: entry)
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
    
    // Save
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            NSLog("Error saving moc :\(error)")
            moc.reset()
        }
    }
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.timeStamp = entryRepresentation.timeStamp
        entry.mood = entryRepresentation.mood
        entry.identifier = entryRepresentation.identifier
        entry.bodyText = entryRepresentation.bodyText
    }
}

// MARK: - Extensions

extension EntryController {
    
    func put(entry: Entry, completion: @escaping () -> Void = { }) {
        guard let identifier = entry.identifier else { return }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            let entryData = try JSONEncoder().encode(entry.entryRepresentation)
            request.httpBody = entryData
        } catch {
            NSLog("Error encoding entry representation:\(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error PUTing entryRep to server:\(error)")
            }
            completion()
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping(NetworkError?) -> Void = { _ in }) {
        guard let identifier = entry.identifier else {
            completion(.noAuth)
            return
        }
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting entry:\(error)")
            }
            completion(nil)
        }.resume()
    }
    
    func fetchSingleEntryFromPersistentStore(identifier: String) -> Entry? {
        
    }
}
