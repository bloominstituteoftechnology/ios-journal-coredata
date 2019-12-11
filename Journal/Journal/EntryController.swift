//
//  EntryController.swift
//  Journal
//
//  Created by Craig Swanson on 12/4/19.
//  Copyright © 2019 Craig Swanson. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    private let baseURL = URL(string: "https://journal-9147c.firebaseio.com/")!
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    // create and update are passed an "Entry" object, so all I need to do here is save.  I wasn't sure what a better way might be while still having the createEntry and updateEntry methods here, as we were instructed to do.
    func createEntry(for entry: Entry) {
        saveToPersistentStore()
    }
    func updateEntry(for entry: Entry) {
        saveToPersistentStore()
    }
    
    // deleteEntry is passed an entry object, deletes it from the array and saves the results.
    func deleteEntry(for entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = {_ in }) {
        guard let identifier = entry.identifier else { return }
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else {
                print("Error creating EntryRepresentation in PUT")
                return
            }
            
            representation.identifier = identifier
            entry.identifier = identifier
            try saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding task \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print("Error PUTing task to server: \(error!)")
                completion(error)
                return
            }
        }.resume()
    }
}
