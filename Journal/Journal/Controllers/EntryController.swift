//
//  EntryController.swift
//  Journal
//
//  Created by Joel Groomer on 10/2/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    let moc = CoreDataStack.shared.mainContext
    
    let baseURL: URL = URL(string: "https://lambda-ios-journal.firebaseio.com/")!
    
    func saveToPersistentStore() {
        do {
            try moc.save()
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    func createEntry(title: String, body: String, mood: EntryMood) {
        let entry = JournalEntry(title: title, bodyText: body, mood: mood)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func updateEntry(entry: JournalEntry, newTitle: String, newBody: String, newMood: EntryMood) {
        guard !newTitle.isEmpty else { return }
        entry.title = newTitle
        entry.bodyText = newBody
        entry.mood = newMood.stringValue
        entry.timestamp = Date()
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func deleteEntry(entry: JournalEntry) {
        moc.delete(entry)
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error deleting entry: \(error)")
        }
        deleteFromServer(entry: entry)
    }
    
    func put(entry: JournalEntry, completion: @escaping (Error?) -> Void = { _ in }) {
        guard var representation = entry.representation else {
            completion(nil)
            return
        }
        
        // create identifier if it doesn't exist
        let uuid = entry.identifier ?? UUID().uuidString
        // set identifier to both entry and representation in case we just created it
        entry.identifier = uuid
        representation.identifier = uuid
        // save the change, if any
        saveToPersistentStore()
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(representation)
        } catch {
            print("Error encoding representation: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error sending entry to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteFromServer(entry: JournalEntry, completion: @escaping (Error?) -> Void = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(nil)
            return
        }
        
        let requestURL = baseURL.appendingPathExtension(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error deleting entry from server: \(error)")
                completion(error)
                return
            }
        }.resume()
    }

}
