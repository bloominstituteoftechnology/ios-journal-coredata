//
//  EntryController.swift
//  Journal
//
//  Created by denis cedeno on 12/4/19.
//  Copyright © 2019 DenCedeno Co. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    typealias CompletionHandler = (Error?) -> Void
    private let baseURL = URL(string: "https://journal-c0a50.firebaseio.com/")!
    
    init() {
        fetchEntriesFromServer()
    }

    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            guard error == nil else {
                print("Error fetching tasks: \(error!)")
                completion(error)
                return
            }
            guard let data = data else {
                print("no data returned by data task")
                completion(NSError())
                return
            }
            do{
                let entryRepresentations = Array(try JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
                
                try self.updateEntries(with: entryRepresentations)
                
                completion(nil)
            } catch {
                print("Error decoding tasks representations: \(error)")
                completion(error)
                return
            }
            
        }.resume()
    }
    
    
    func put(entry: Entry, completion: @escaping () -> Void = { }){
        
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
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding task \(entry): \(error)")
            completion()
            return
        }
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print("Error PUTing entry to server: \(error!)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    
    
    func create(title: String, bodyText: String, mood: String, timeStamp: Date) {
        
        let entry = Entry(title: title, bodyText: bodyText, mood: mood, timeStamp: timeStamp)
        put(entry: entry)
        CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timeStamp = Date()
        put(entry: entry)
        CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        
        
    }
    
    private func updateEntries(with representations: [EntryRepresentation]) throws {
        
        let entriesWithID = representations.filter { $0.identifier != nil }
        let identifiersToFetch = entriesWithID.compactMap { UUID(uuidString: $0.identifier!) }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
        var entriesToCreate =  representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.perform {
            do {
                let exsistingEntries = try context.fetch(fetchRequest)
                for entry in exsistingEntries {
                    guard let id = entry.identifier,
                        let representation = representationsByID[id] else {
                            let moc = CoreDataStack.shared.mainContext
                            moc.delete(entry)
                            continue
                    }
                    
                    entry.title = representation.title
                    entry.bodyText = representation.bodyText
                    entry.mood = representation.mood
                    entry.timeStamp = representation.timeStamp
                    
                    entriesToCreate.removeValue(forKey: id)
                }
                for representation in entriesToCreate.values {
                    Entry(entryRepresentation: representation, context: context)
                }
            } catch {
                print("Error fetching tasks for UUIDs: \(error)")
            }
        }
        
        
        CoreDataStack.shared.save(context: context)
    }
    
    func delete(for entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        deleteEntryFromServer(entry)
        CoreDataStack.shared.save()
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in}) {
        guard let identifier = entry.identifier else {
            completion(NSError())
            return
        }
        let requestURL = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    
}
