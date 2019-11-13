//
//  EntryController.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation
import CoreData

class EntryController: NSObject {
    // MARK: - Properties
    
    private var coreDataStack = CoreDataStack()
    
    let baseURL: URL = URL(string: "https://lambda-ios-journal-bc168.firebaseio.com/")!
    var delegate: CoreDataStackDelegate? {
        get {
            return coreDataStack.delegate
        } set {
            coreDataStack.delegate = newValue
        }
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
        self.fetchEntriesFromServer()
    }
    
    // MARK: - CRUD
    
    func create(entryWithTitle title: String, body: String, mood: Entry.Mood) {
        let entry = Entry(
            title: title,
            bodyText: body,
            mood: mood,
            context: coreDataStack.context
        )
        saveToPersistentStore()
        putToServer(entry: entry)
    }
    
    func update(entry: Entry, withNewTitle title: String, body: String, mood: Entry.Mood) {
        entry.title = title
        entry.bodyText = body
        entry.mood = mood.rawValue
        saveToPersistentStore()
        putToServer(entry: entry)
    }
    
    func update(entry: Entry, from representation: Entry.Representation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
        entry.identifier = representation.identifier
    }
    
    func delete(entry: Entry) {
        coreDataStack.context.delete(entry)
        deleteEntryFromServer(entry)
        saveToPersistentStore()
    }
    
    // MARK: - Local Fetching
    
    private var fetchedResultsAreEmpty: Bool {
        guard let array = coreDataStack.fetchedResultsController.fetchedObjects
            else { return true }
        return array.isEmpty
    }
    
    func fetch(entryAt indexPath: IndexPath) -> Entry? {
        return coreDataStack.fetchedResultsController.object(at: indexPath)
    }
    
    func mood(forIndex index: Int) -> String? {
        if fetchedResultsAreEmpty { return nil }
        let sectionInfo = coreDataStack.fetchedResultsController.sections?[index]
        return sectionInfo?.name.capitalized
    }
    
    func numberOfMoods() -> Int {
        if fetchedResultsAreEmpty { return 0 }
        return coreDataStack.fetchedResultsController.sections?.count ?? 1
    }
    
    func numberOfEntries(forIndex index: Int) -> Int {
        if fetchedResultsAreEmpty { return 0 }
        return coreDataStack.fetchedResultsController.sections?[index].numberOfObjects ?? 0
    }
    
    func saveToPersistentStore() {
        let moc = coreDataStack.context
        do {
            try moc.save()
        } catch {
            print("Error saving journal entries: \(error)")
        }
    }
    
    // MARK: - Sync
    
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
            } catch {
                print("Error decoding entry representations: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    private func putToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let id = entry.identifier else {
            print("")
            return
        }
        var request = urlRequest(for: id)
        request.httpMethod = HTTPMethod.put
        
        do {
            guard var representation = entry.representation else {
                print("Error: failed to get entry representation.")
                completion(nil)
                return
            }
            representation.identifier = id
            entry.identifier = id
            saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error PUTing task to server: \(error)")
            }
            completion(error)
        }.resume()
    }
    
    private func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
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
    
    private func updateEntries(from representations: [Entry.Representation]) {
        let idsToFetch = representations.compactMap { $0.identifier }
        let representationsByID = Dictionary(
            uniqueKeysWithValues: zip(idsToFetch, representations)
        )
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", argumentArray: idsToFetch)
        
        do {
            let existingEntries = try coreDataStack.context.fetch(fetchRequest)
            
            for entry in existingEntries {
                guard let id = entry.identifier,
                    let representation = representationsByID[id]
                    else { continue }
                self.update(entry: entry, from: representation)
                entriesToCreate.removeValue(forKey: id)
            }
            
            for representation in entriesToCreate.values {
                Entry(representation: representation, context: coreDataStack.context)
            }
        } catch {
            print("Error fetch tasks for IDs: \(error)")
        }
        
        saveToPersistentStore()
    }
}

// MARK: - Type Aliases

extension EntryController {
    typealias ChangeType = NSFetchedResultsChangeType
    typealias CompletionHandler = (Error?) -> Void
}

