//
//  EntryController.swift
//  Journal
//
//  Created by Michael Stoffer on 7/10/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-core-data-eed2a.firebaseio.com/")!

class EntryController {
    typealias CompletionHandler = (Error?) -> Void
    
    func createEntry(withTitle title: String, withBodyText bodyText: String?, withMood mood: EntryMood) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        self.saveToPersistentStore()
        self.put(entry: entry)
    }
    
    func updateEntry(withEntry entry: Entry, withTitle title: String, withBodyText bodyText: String?, withMood mood: EntryMood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        entry.timestamp = Date()
        self.saveToPersistentStore()
        self.put(entry: entry)
    }
    
    func deleteEntry(withEntry entry: Entry) {
        self.deleteEntryFromServer(entry) { (error) in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                return
            }
            
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            self.saveToPersistentStore()
        }
    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier ?? UUID().uuidString
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else { completion(NSError()); return }
            
            representation.identifier = uuid
            entry.identifier = uuid
            self.saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding task \(entry): \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTing task to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            print(response!)
            completion(error)
        }.resume()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            NSLog("Error saving managed object context: \(error)")
        }
    }
}
