//
//  APIController.swift
//  Journal
//
//  Created by morse on 11/12/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation
import CoreData

class APIController {
    
    static let baseURL = URL(string: "https://journal-4de34.firebaseio.com/")!
    
    static func fetchEntriesFromServer(completion: @escaping () -> Void = { }) {
        
        let requestURL = APIController.baseURL.appendingPathExtension("json")
        print(requestURL)
        
        let request = URLRequest(url: requestURL)
        print(request)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            //            print(request)
            if let error = error {
                print("Error fetching tasks: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                print("No data returned from data task.")
                completion()
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let decoded = try jsonDecoder.decode([String: EntryRepresentation].self, from: data).map { $0.value }
                self.updateEntries(with: decoded)
                completion()
            } catch {
                print("Unable to decode data into object of type [EntryRepresentation]: \(error)")
                completion()
            }
            
            
        }.resume()
    }
    
    static func updateEntries(with representations: [EntryRepresentation]) {
        
        let identifiersToFetch = representations.map { $0.identifier }
        
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
                entry.identifier = representation.identifier
                entry.mood = representation.mood
                entry.timestamp = representation.timestamp
                entry.bodyText = representation.bodyText
                
                entriesToCreate.removeValue(forKey: identifier)
                
                
            }
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
            
            do {
                let moc = CoreDataStack.shared.mainContext
                try moc.save()
            } catch {
                print("Error saving managed object context: \(error)")
            }
        } catch {
            print("Error fetching tasks from persistent store: \(error)")
        }
    }
    
    struct HTTPMethod {
        static let get = "GET"
        static let put = "PUT"
        static let post = "POST"
        static let delete = "DELETE"
    }
    
    static func put(entry: Entry, completion: @escaping () -> Void = { }) {
        
        let identifier = entry.identifier ?? UUID().uuidString
        entry.identifier = identifier
        
        let requestURL = baseURL
            .appendingPathComponent(identifier)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put
        
        guard let entryRepresentation = entry.entryRepresentation else {
            print("Entry Representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            print("Error encoding task representation: \(error)")
            completion()
            return
        }
        print(request)
        URLSession.shared.dataTask(with: request) { _, _, error in
            
            if let error = error {
                print("Error PUTting data: \(error)")
                completion()
                return
            }
            
            completion()
        }.resume()
    }
    
    static func delete(entry: Entry, completion: @escaping () -> Void = { }) {
        
        let identifier = entry.identifier ?? UUID().uuidString
        entry.identifier = identifier
        
        let requestURL = baseURL
            .appendingPathComponent(identifier)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete
        
        guard let entryRepresentation = entry.entryRepresentation else {
            print("Entry Representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            print("Error encoding task representation: \(error)")
            completion()
            return
        }
        print(request)
        URLSession.shared.dataTask(with: request) { _, _, error in
            
            if let error = error {
                print("Error PUTting data: \(error)")
                completion()
                return
            }
            
            completion()
        }.resume()
    }
    
}
