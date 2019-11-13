//
//  EntryController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_204 on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-coredata-ss.firebaseio.com/")!

class EntryController {
    
    // MARK: - Properties

    
    // MARK: - Functions
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving managed object context: \(error)")
        }
    }
    
    func put(entry: Entry, completion: @escaping () -> Void = { }) {
        let uuid = entry.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion()
                return
            }
            
            representation.identifier = uuid.uuidString
            entry.identifier = uuid
            saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding entry: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            completion()
            
            if let error = error {
                print("Error putting entry to server \(error)")
                return
            }
        }.resume()
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }
            if let error = error {
                print("Error deleting entry to server \(error)")
                completion(error)
                return
            }
        }.resume()
    }

    // MARK: CRUD Methods
    
    func create(title: String, timestamp: Date, mood: String, bodyText: String?) {
        let entry = Entry(title: title, timestamp: timestamp, mood: mood, bodyText: bodyText)
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func update(for entry: Entry, title: String, bodyText: String?, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func delete(for entry: Entry) {
        deleteEntryFromServer(entry)
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
}
