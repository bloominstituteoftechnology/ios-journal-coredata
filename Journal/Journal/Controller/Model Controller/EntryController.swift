//
//  EntryController.swift
//  Journal
//
//  Created by Chad Rutherford on 12/16/19.
//  Copyright © 2019 Chad Rutherford. All rights reserved.
//

import CoreData
import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class EntryController {
    
    typealias CompletionHandler = (Error?) -> ()
    private let baseURL = URL(string: "https://journal-f8c88.firebaseio.com/")
    
    init() {
        fetchEntriesFromServer()
    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let identifier = entry.identifier ?? UUID().uuidString
        guard let requestURL = baseURL?.appendingPathComponent(identifier).appendingPathExtension("json") else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        let encoder = JSONEncoder()
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            
            representation.identifier = identifier
            entry.identifier = identifier
            try saveToPersistentStore()
            request.httpBody = try encoder.encode(representation)
        } catch let encodeError {
            print("Error encoding entry: \(encodeError.localizedDescription)")
            completion(encodeError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error PUTting entry to server: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(error)
                    return
                }
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    func createEntry(title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
        try? saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        put(entry: entry)
        try? saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        deleteEntryFromServer(entry)
        moc.delete(entry)
        do {
            try moc.save()
        } catch let deleteError {
            moc.reset()
            print("Error deleting entries: \(deleteError.localizedDescription)")
        }
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier, let requestURL = baseURL?.appendingPathComponent(identifier).appendingPathExtension("json") else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error deleting entry from server: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(error)
                    return
                }
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    private func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.timestamp = representation.timestamp
        entry.identifier = representation.identifier
        entry.mood = representation.mood
    }
    
    private func updateEntries(with representations: [EntryRepresentation]) throws {
        let entriesWithID = representations.filter { $0.identifier != "" }
        let identifiersToFetch = entriesWithID.compactMap { $0.identifier }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
        var entriesToCreate = representationsByID
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        let moc = CoreDataStack.shared.mainContext
        do {
            let existingEntries = try moc.fetch(fetchRequest)
            
            for entry in existingEntries {
                guard let id = entry.identifier,
                    let representation = representationsByID[id] else { continue }
                self.update(entry: entry, with: representation)
                entriesToCreate.removeValue(forKey: id)
                try saveToPersistentStore()
            }
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: moc)
                try saveToPersistentStore()
            }
        } catch let fetchError {
            print("Error fetching entries for identifiers: \(fetchError.localizedDescription)")
        }
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        guard let url = baseURL?.appendingPathExtension("json") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching entries: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else {
                print("No data returned by data task")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let entryRepresentations = Array(try decoder.decode([String : EntryRepresentation].self, from: data).values)
                try self.updateEntries(with: entryRepresentations)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch let decodeError {
                print("Error decoding entry representations: \(decodeError.localizedDescription)")
                DispatchQueue.main.async {
                    completion(decodeError)
                }
                return
            }
        }.resume()
    }
}
