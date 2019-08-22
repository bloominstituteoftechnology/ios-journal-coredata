//
//  EntryController+ServerManipulation.swift
//  Journal
//
//  Created by Jake Connerly on 8/22/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreData

extension EntryController {
    
    // Put Method
    func put(entry: Entry, completion: @escaping () -> Void = { }) {
        guard let identifier = entry.identifier else { return }
        
        let requestURL     = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request        = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            let entryData    = try JSONEncoder().encode(entry.entryRepresentation)
            request.httpBody = entryData
        } catch {
            NSLog("Error encoding entry representation:\(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error PUTing entryRep to server:\(error)")
            }
            completion()
        }.resume()
    }
    
    // Delete Entry From Server Method
    func deleteEntryFromServer(entry: Entry, completion: @escaping(NetworkError?) -> Void = { _ in }) {
        guard let identifier = entry.identifier else {
            completion(.noAuth)
            return
        }
        
        let requestURL     = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request        = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting entry:\(error)")
            }
            completion(nil)
        }.resume()
    }
    
    // Fetch SINGLE Entry From Server Method
    func fetchSingleEntryFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Entry? {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        var entry: Entry? = nil
        context.performAndWait {
            do {
                entry = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching entry with identifier \(identifier):\(error)")
                entry = nil
            }
        }
        return entry
    }
    
    // Fetch ALL Entries From Server Method
    func fetchEntriesFromServer(completion: @escaping() -> Void) {
        
        let requestURL     = baseURL.appendingPathExtension("json")
        var request        = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error fetching entries from server:\(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("Error GETing data from all entries")
                completion()
                return
            }
            
            do {
                let entriesDictionary = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                let entryRepArray     = entriesDictionary.map({ $0.value })
                let moc               = CoreDataStack.shared.container.newBackgroundContext()
                
                self.updatePersistentStore(forTasksIn: entryRepArray, for: moc)
            } catch {
                NSLog("error decoding entries:\(error)")
            }
            completion()
        }.resume()
    }
}
