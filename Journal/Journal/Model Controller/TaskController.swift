//
//  TaskController.swift
//  Journal
//
//  Created by Breena Greek on 4/28/20.
//  Copyright © 2020 Breena Greek. All rights reserved.
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

class TaskController {
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    let baseURL = URL(string: "https://journal-163be.firebaseio.com/")!
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler) {
        
        guard let identifier = entry.identifier?.uuidString else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        // Turn the task into a task representation, then TR into JSon.
        
        do {
            guard let taskRepresentation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            
            request.httpBody = try JSONEncoder().encode(taskRepresentation)
        } catch {
            NSLog("Error encoding task \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting tassk to server: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
        guard let identifier = entry.identifier?.uuidString else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        // Turn the task into a task representation, then TR into JSon.
        
        do {
            guard let taskRepresentation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            
            request.httpBody = try JSONEncoder().encode(taskRepresentation)
        } catch {
            NSLog("Error encoding task \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting tassk to server: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }
    
    func fetchTasksFromServer(completion: @escaping CompletionHandler = { _ in }) {
        
         let requestURL = baseURL.appendingPathExtension("json")
            
            URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
                
                if let error = error {
                    NSLog("Error fetching tasks: \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(.otherError))
                    }
                    return
                }
                
                guard let data = data else {
                    NSLog("Error: No data returned from data task")
                    DispatchQueue.main.async {
                        completion(.failure(.noData))
                    }
                    return
                }
                
                // Pull the JSON out of the data, and turn it into [TaskRepresentation]
                do {
                    let entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                    
                    // Figure out which task representations don't exist in Core Data, so we can add them, and figure out which ones have changed
                    try self.updateTasks(with: entryRepresentations)
                    
                    DispatchQueue.main.async {
                        completion(.success(true))
                    }
                } catch {
                    NSLog("Error decoding task representations: \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(.noDecode))
                    }
                }
            }.resume()
        }
    
    func updateTasks(with representations: [EntryRepresentation]) throws {
        
        let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier) })
        
        let representationsByID = Dictionary(uniqueKeysWithValues:
            zip(identifiersToFetch, representations)
        )
        
        // Make a copy of the representations by ID for later use
        var entriesToCreate = representationsByID
        
        // Ask CoreData to find any tasks with these identifiers
        // if identifiersToFetch.contains(someTaskincoreData)
        let predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = predicate
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.performAndWait {
            
            do {
                // This will only fetch request that match the criteria in our predicate
                let existingTasks = try context.fetch(fetchRequest)
                
                // Lets update the tasks that already exist in Core Data
                for task in existingTasks {
                    guard let id = task.identifier,
                        let representation = representationsByID[id] else { continue }
                    
                    //                entry.title = representation.title
                    //                entry.bodyText = representation.bodyText
                    //                entry.complete = representation.complete
                    //                entry.priority = representation.priority
                    
                    // If we updated the task, tht means we dont need to make a copy of it, it already exists in Core Data, so remove it from te task we still need to create.
                    entriesToCreate.removeValue(forKey: id)
                }
                
                // Add the tasks that dont exist
                for representation in entriesToCreate.values {
                    Entry(entryRepresentation: representation, context: context)
                }
                
            } catch {
                NSLog("Error fetching tasks for UUID: \(error)")
            }
        }
        
        try CoreDataStack.shared.saveContext(context: context)
    }
}
