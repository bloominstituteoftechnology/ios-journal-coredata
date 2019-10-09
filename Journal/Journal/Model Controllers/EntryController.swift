//
//  EntryController.swift
//  Journal
//
//  Created by Vici Shaweddy on 10/2/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    let baseURL = URL(string: "https://journal-7b7fa.firebaseio.com/")!
    
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
            self.saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding entry \(entry): \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error PUTting entry to server: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error DELETEing entry to server: \(error)")
                completion(error)
                return
            }
            completion(error)
        }.resume()
    }

    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            print("Error saving to core data: \(error)")
        }
    }
    
    func create(mood: EntryMood, title: String, bodyText: String?) {
    
        let entry = Entry(mood: mood, title: title, bodyText: bodyText)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
            self.put(entry: entry)
        } catch {
            print("Error saving managed object content: \(error)")
        }
    }
    
    func update(entry: Entry, mood: String, title: String, bodyText: String, timestamp: Date = Date()) {
        entry.mood = mood
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
            self.put(entry: entry)
        } catch {
            print("Error saving managed object content: \(error)")
        }
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        do {
            try moc.save()
            self.deleteEntryFromServer(entry: entry)
        } catch {
            moc.reset()
            print("Error saving managed object context: \(error)")
        }
    }

}

