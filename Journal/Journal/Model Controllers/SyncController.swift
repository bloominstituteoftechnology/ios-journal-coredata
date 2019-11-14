//
//  SyncController.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-14.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation

// MARK: - Sync Controller Delegate

protocol SyncControllerDelegate {
    var coreDataStack: CoreDataStack { get }
    
    func fetch(request: EntryController.FetchRequest) throws -> [Entry]
    func fetchAllEntriesFromLocalStore() -> [Entry]
    func update(entry: Entry, from: Entry.Representation)
    func saveToLocalPersistentStore()
}

class SyncController {
    
    // MARK: - Properties
    
    var delegate: SyncControllerDelegate?
    let baseURL: URL = URL(string: "https://lambda-ios-journal-bc168.firebaseio.com/")!
    
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - URL Requests
    
    private func urlRequest(for id: String?) -> URLRequest {
        if let id = id {
            return URLRequest(url:
                baseURL.appendingPathComponent(id)
                .appendingPathExtension(.json)
            )
        }
        return URLRequest(url: baseURL.appendingPathExtension(.json))
    }
    
    private func urlRequest() -> URLRequest {
        return urlRequest(for: nil)
    }
    
    // MARK: - Fetch
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let request = urlRequest()
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching entries: \(error)")
                completion(error)
                return
            }
            guard let data = data else {
                print("No data returned by data task!")
                completion(nil)
                return
            }
            
            do {
                let entryRepresentations = Array(try JSONDecoder().decode(
                    [String : Entry.Representation].self,
                    from: data
                ).values)
                self.updateEntries(from: entryRepresentations)
                if let allLocalEntries = self.delegate?.fetchAllEntriesFromLocalStore() {
                    for entry in allLocalEntries {
                        if let rep = entry.representation,
                            !entryRepresentations.contains(rep) {
                            self.putToServer(entry: entry)
                        }
                    }
                }
            } catch {
                print("Error decoding entry representations: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    // MARK: - Put
    
    func putToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        entry.handleBadID()
        guard let id = entry.identifier else {
            print("")
            return
        }
        var request = urlRequest(for: id)
        request.httpMethod = HTTPMethod.put
        
        do {
            guard let representation = entry.representation else {
                print("Error: failed to get entry representation.")
                completion(nil)
                return
            }
            delegate?.saveToLocalPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error PUTing task to server: \(error)")
            }
            completion(error)
        }.resume()
    }
    
    func updateEntries(from representations: [Entry.Representation]) {
        let idsToFetch = representations.compactMap { $0.identifier }
        let representationsByID = Dictionary(
            uniqueKeysWithValues: zip(idsToFetch, representations)
        )
        var entriesToCreate = representationsByID
        
        let fetchRequest: EntryController.FetchRequest = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", idsToFetch)
        
        do {
            if let existingEntries = try delegate?.fetch(request: fetchRequest) {
                for entry in existingEntries {
                    guard let id = entry.identifier,
                        let representation = representationsByID[id]
                        else { continue }
                    delegate?.update(entry: entry, from: representation)
                    entriesToCreate.removeValue(forKey: id)
                }
                for representation in entriesToCreate.values {
                    guard let context = delegate?.coreDataStack.context else {
                        print("Error getting context of CoreDataStack!")
                        return
                    }
                    Entry(representation: representation, context: context)
                }
            }
        } catch {
            print("Error fetch tasks for IDs: \(error)")
        }
        
        delegate?.saveToLocalPersistentStore()
    }
    
    // MARK: - Delete
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let id = entry.identifier else {
            print("Error: entry has no identifier!")
            completion(nil)
            return
        }
        var request = urlRequest(for: id)
        request.httpMethod = HTTPMethod.delete
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            print(response ?? "No response!")
            completion(error)
        }.resume()
    }
}
