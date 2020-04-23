//
//  JournalController.swift
//  Journal
//
//  Created by Chris Dobek on 4/22/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}

let baseURL = URL(string: "https://journal-d7156.firebaseio.com/")!

class JournalController {
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    init(){
        fetchEntriesFromServer()
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from fetch")
                completion(.failure(.noData))
                return
            }
            
            do {
                let journalRepresentations = Array(try JSONDecoder().decode([String: JournalRepresentation].self, from: data).values)
                try self.updateEntries(with: journalRepresentations)
                completion(.success(true))
            } catch {
                NSLog("Error decoding tasks from server: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard let representation = entry.journalRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding entry \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error sending task to server: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error deleting task from server: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    private func updateEntries(with representations: [JournalRepresentation]) throws {
        let identifiersToFetch = representations.compactMap { UUID(uuidString: $0.identifier)}
        let representationsbyID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var entryToCreate = representationsbyID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.perform {
            do {
                let existingEntry = try context.fetch(fetchRequest)
                
                for entry in existingEntry {
                    guard let id = entry.identifier,
                        let representation = representationsbyID[id] else { continue }
                    self.update(entry: entry, with: representation)
                    entryToCreate.removeValue(forKey: id)
                }
                
                for representation in entryToCreate.values {
                    Entry(journalRepresentation: representation, context: context)
                }
                 try context.save()
            } catch {
                NSLog("Error fetching tasks with UUIDs: \(identifiersToFetch), with error: \(error)")
            }
        }
    }
    private func update(entry: Entry, with representation: JournalRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
    }
}
