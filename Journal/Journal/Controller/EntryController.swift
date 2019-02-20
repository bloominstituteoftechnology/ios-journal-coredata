//
//  EntryController.swift
//  Journal
//
//  Created by Paul Yi on 2/18/19.
//  Copyright © 2019 Paul Yi. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    let moc = CoreDataStack.shared.mainContext
    let baseURL = URL(string: "https://journal-a1cc9.firebaseio.com/")!
    
    func saveToPersistentStore() {
        do {
            try moc.save()
        }
        catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    // MARK: - CRUD methods
    
    func create(title: String, bodyText: String, mood: EntryMood) {
        let _ = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, timestamp: Date = Date(), mood: EntryMood = .neutral) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        entry.mood = mood.rawValue
        
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        moc.delete(entry)
        saveToPersistentStore()
    }
    
    func put(entry: Entry, completion: @escaping ((Error?) -> Void) = { _ in }) {
        guard let identifer = entry.identifier else { completion(NSError()); return }
        
        let requestURL = baseURL.appendingPathComponent(identifer).appendingPathComponent("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
        }
        catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error updating entry: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
        
    }
    
}
