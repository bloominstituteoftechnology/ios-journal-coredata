//
//  EntryController.swift
//  Journal
//
//  Created by John Kouris on 10/1/19.
//  Copyright © 2019 John Kouris. All rights reserved.
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
    
    let baseURL = URL(string: "https://journal-f54c4.firebaseio.com/")!
    
    func put(entry: Entry, completion: @escaping () -> Void = {}) {
        let identifier = entry.identifier ?? UUID()
        entry.identifier = identifier
        
        let requestURL = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let entryRepresentation = entry.entryRepresentation else {
            print("Entry Representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            print("Error encoding entry representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error PUTing entry: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func fetchEntriesFromServer(completion: @escaping () -> Void = {}) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error fetching tasks: \(error)")
                completion()
            }
            
            guard let data = data else {
                print("No data returned from data task")
                completion()
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let entryRepresentations = try decoder.decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                self.updateEntries(with: entryRepresentations)
            } catch {
                print("Error decoding: \(error)")
            }
        }.resume()
    }
    
    func updateEntries(with representations: [EntryRepresentation]) {
        let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier) })
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        var entriesToCreate = representationsByID
        
        do {
            let context = CoreDataStack.shared.mainContext
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
            
            let existingEntries = try context.fetch(fetchRequest)
            
            for entry in existingEntries {
                guard let identifier = entry.identifier,
                    let representation = representationsByID[identifier] else { continue }
                
                entry.title = representation.title
                entry.bodyText = representation.bodyText
                entry.mood = representation.mood
                
                entriesToCreate.removeValue(forKey: identifier)
            }
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
            
            saveToPersistentStore()
        } catch {
            print("Error fetching entries from persistent store: \(error)")
        }
    }
    
    func saveToPersistentStore() {
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    @discardableResult func createEntry(with title: String, bodyText: String?, mood: Mood) -> Entry {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood, context: CoreDataStack.shared.mainContext)
        saveToPersistentStore()
        return entry
    }
    
    func updateEntry(entry: Entry, with title: String, bodyText: String?, mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
}
