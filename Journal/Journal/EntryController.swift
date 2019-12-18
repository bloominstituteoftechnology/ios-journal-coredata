//
//  EntryController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_218 on 12/16/19.
//  Copyright © 2019 Lambda_School_Loaner_218. All rights reserved.
//

import CoreData
import Foundation

enum HTTPMethood: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class EntryController {
    
    typealias CompletionHandler = (Error?) -> Void
    private let baseURL = URL(string: "https://journal-dca4e.firebaseio.com/")
    
    init() {
        fetchEntriesFromServer()
    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let identifire = entry.identifier ?? UUID().uuidString
        guard let requestURL = baseURL?.appendingPathComponent(identifire).appendingPathExtension("json") else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethood.put.rawValue
        
        let encoder = JSONEncoder()
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = identifire
            entry.identifier = identifire
            try saveToPersistentStore()
            request.httpBody = try encoder.encode(representation)
        } catch let encodeError {
            print("Error encoding entry: \(encodeError.localizedDescription)")
            completion(encodeError)
            return
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error putting entry to server: \(error.localizedDescription)")
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
    
    func saveToPersistentStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
    
    func createEntry(title: String, bodyText: String, mood:String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
        try? saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodytext = bodyText
        entry.timestamp = Date()
        entry.mood = mood
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
            print("Error deleting entry \(deleteError.localizedDescription)")
        }
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = {_ in}) {
        guard let identifier = entry.identifier, let requestURL = baseURL?.appendingPathComponent(identifier).appendingPathExtension("json") else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethood.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                print("Error deleteing entry from server: \(error.localizedDescription)")
                DispatchQueue.main.async{
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
        entry.bodytext = representation.bodyText
        entry.identifier = representation.identifier
        entry.mood = representation.mood
    }
    
    private func updateEntries(with repersentations: [EntryRepresentation]) throws {
        let entriesWithID = repersentations.filter { $0.identifier != "" }
        let iddentifiersToFetch = entriesWithID.compactMap { $0.identifier }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(iddentifiersToFetch,entriesWithID))
        var entriesToCreate = representationsByID
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", iddentifiersToFetch)
        let moc = CoreDataStack.shared.mainContext
        do {
            let exsistingEntries = try moc.fetch(fetchRequest)
            
            for entry in exsistingEntries {
                guard let id = entry.identifier,
                    let representation = representationsByID[id] else { continue }
                self.update(entry: entry, with: representation)
                entriesToCreate.removeValue(forKey: id)
               try? saveToPersistentStore()
            }
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: moc)
                try saveToPersistentStore()
            }
        } catch let fetchError {
            print("Error fetching entries for identifiers: \(fetchError.localizedDescription)")
        }
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = {_ in }) {
        guard let url = baseURL?.appendingPathExtension("json") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
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
                let entryRepresentations = Array(try decoder.decode([String: EntryRepresentation].self, from: data).values)
                try self.updateEntries(with: entryRepresentations)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch let decoderError {
                print("Error decoding entry representations \(decoderError.localizedDescription)")
                DispatchQueue.main.async {
                    completion(decoderError)
                }
                return
            }
        }.resume()
        
    }
}
