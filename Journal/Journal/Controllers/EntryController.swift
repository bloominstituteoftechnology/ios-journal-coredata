//
//  EntryController.swift
//  Journal
//
//  Created by Sean Acres on 7/22/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
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
    
    let baseURL = URL(string: "https://journal-9006c.firebaseio.com/")!
    
    func createEntry(title: String, bodyText: String?, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String?, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        
        moc.delete(entry)
        deleteEntryFromServer(entry: entry)
        saveToPersistentStore()
    }
    
    func put(entry: Entry, completion: @escaping () -> Void = { }) {
        let uuid = entry.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(entry.entryRepresentation)
        } catch {
            NSLog("Error encoding entry \(entry): \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTting entry to server: \(error)")
                completion()
                return
            }
            
            completion()
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        let uuid = entry.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            NSLog("Error saving MOC: \(error)")
            moc.reset()
        }
    }
}
