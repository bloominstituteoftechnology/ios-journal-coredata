//
//  EntryController.swift
//  Journal
//
//  Created by Mitchell Budge on 6/3/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    //MARK: - Methods
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func createEntry(title: String, bodyText: String, timestamp: Date, identifier: String, mood: Mood) {
        let entry = Entry(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, mood: mood)
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        deleteEntryFromServer(entry: entry)
        saveToPersistentStore()
    }

    // MARK: - Networking
    
    typealias CompletionHandler = (Error?) -> Void
    
    let baseURL = URL(string: "https://journal-72b8d.firebaseio.com/")!
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in}) {

        let requestURL = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion(error)
                return
            }

            guard let data = data else {
                NSLog("No data returned by data task")
                completion(NSError())
                return
            }

            DispatchQueue.main.async {
                do {
                    let entryRepresentationsDict = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                    let entryRepresentations = Array(entryRepresentationsDict.values)

                    for entryRep in entryRepresentations {

                        let identifier = entryRep.identifier
                        if let entry = self.fetchSingleEntryFromPersistentStore(identifier: identifier!) {
                            self.update(entry: entry, with: entryRep)
                        } else {
                            let _ = Entry(entryRepresentation: entryRep)
                        }
                    }
                    self.saveToPersistentStore()
                } catch {
                    NSLog("Error decoding entries: \(error)")
                    completion(error)
                    return
                }

                completion(nil)
            }
            }.resume()

    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in}) {
        
        let uuid = entry.identifier ?? UUID().uuidString
        entry.identifier = uuid
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            let representation = entry.entryRepresentation
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding task: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTTING task to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in}) {
        
        let uuid = entry.identifier ?? UUID().uuidString
        entry.identifier = uuid
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error DELETEing task to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
        
    }
    
    private func fetchSingleEntryFromPersistentStore(identifier: String) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        let moc = CoreDataStack.shared.mainContext
        return (try? moc.fetch(fetchRequest))?.first
    }
    
    func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.timestamp = representation.timestamp
        entry.mood = representation.mood
    }
    
}
