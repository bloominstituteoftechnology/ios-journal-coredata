//
//  EntryController.swift
//  Journal
//
//  Created by Thomas Sabino-Benowitz on 11/13/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://tsb-journal.firebaseio.com/")!

class EntryController {
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchEntriesFromServer()
    }
    //    MARK: + Task Actions
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                print("Error fetching tasks: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("No data returned by data task")
                completion(NSError())
                return
            }
            
            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                try self.updateEntries(with: entryRepresentations)
                completion(nil)
            } catch {
                print("Error decoding task representations: \(error)")
                completion(error)
                return
            }
            
        }.resume()
    }
    
    func sendTaskToServer(entry: Entry, completion: @escaping () -> () = { }) {
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
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding task: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            completion()
            
            if let error = error {
                print("Error PUTing task to server; \(error)")
            }
            if let response = response {
                print("\(response)")
            }
        }.resume()
    }
    
    func deleteEntry(_ entry: Entry, completion: @escaping (CompletionHandler) = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(NSError())
            return
        }
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            context.delete(entry)
            try CoreDataStack.shared.save(context: context)
        } catch {
            context.reset()
            print("Error deleting object from managed object context:\(error)")
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { data, response, error in
            print(response!)
            completion(error)
        }.resume()
    }
    
    
    private func updateEntries(with representations: [EntryRepresentation]) throws {
        let entriesWithID = representations.filter{ $0.identifier != nil }
        let identifiersToFetch = entriesWithID.compactMap {UUID(uuidString: $0.identifier!)}
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
        
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        do {
            let existingTasks = try context.fetch(fetchRequest)
            for entry in existingTasks {
                guard let id = entry.identifier,
                    let representation = representationsByID[id] else { continue }
                
                self.update(entry: entry, with: representation)
                entriesToCreate.removeValue(forKey: id)
            }
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation)
            }
        } catch {
            print("Error fetching tasks for UUIDs: \(error)")
        }
        try CoreDataStack.shared.save(context: context)
    }
    
    
    private func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
        
    }
    
    
    //    func saveToPersistentStore() throws {
    //           let moc = CoreDataStack.shared.mainContext
    //           try moc.save()
    //       }
    
}

