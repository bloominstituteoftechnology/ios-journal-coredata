//
//  EntryController.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-11.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Entry Controller Delegate

protocol EntryControllerDelegate {
    func entriesWillChange()
    func entriesDidChange()
    func sectionChanged(atIndex sectionIndex: Int, with type: EntryController.ChangeType)
    func entryChanged(from indexPath: IndexPath?, to newIndexPath: IndexPath?, with type: EntryController.ChangeType)
}

class EntryController: NSObject {
    // MARK: - Properties
    
    private var coreDataStack = CoreDataStack()
    var delegate: EntryControllerDelegate?
    
    let baseURL: URL = URL(string: "https://lambda-ios-journal-bc168.firebaseio.com/")!
    
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - Local Fetching
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "mood", ascending: true),
            NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.mainContext,
            sectionNameKeyPath: "mood",
            cacheName: nil
        )
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print("Error fetching results from data: \(error)")
        }
        return frc
    }()
    
    private var fetchedResultsAreEmpty: Bool {
        guard let array = fetchedResultsController.fetchedObjects
            else { return true }
        return array.isEmpty
    }
    
    func fetch(entryAt indexPath: IndexPath) -> Entry? {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func mood(forIndex index: Int) -> String? {
        if fetchedResultsAreEmpty { return nil }
        let sectionInfo = fetchedResultsController.sections?[index]
        return sectionInfo?.name.capitalized
    }
    
    func numberOfMoods() -> Int {
        if fetchedResultsAreEmpty { return 0 }
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func numberOfEntries(forIndex index: Int) -> Int {
        if fetchedResultsAreEmpty { return 0 }
        return fetchedResultsController.sections?[index].numberOfObjects ?? 0
    }
    
    // MARK: - Sync
    
    private func urlRequest(for id: String) -> URLRequest {
        let url = baseURL.appendingPathComponent(id).appendingPathExtension(.json)
        return URLRequest(url: url)
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
    
    func update(entry: Entry, from representation: Entry.Representation) {
        
    }
    
    // MARK: - CRUD
    
    func create(entryWithTitle title: String, body: String, mood: Entry.Mood) {
        let entry = Entry(
            title: title,
            bodyText: body,
            mood: mood,
            context: coreDataStack.mainContext
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
    
    func delete(entry: Entry) {
        coreDataStack.mainContext.delete(entry)
        deleteEntryFromServer(entry)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        let moc = coreDataStack.mainContext
        do {
            try moc.save()
        } catch {
            print("Error saving journal entries: \(error)")
        }
    }
}

// MARK: - Fetched Results Controller Delegate

extension EntryController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.entriesWillChange()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.entriesDidChange()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        delegate?.sectionChanged(atIndex: sectionIndex, with: type)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        delegate?.entryChanged(from: indexPath, to: newIndexPath, with: type)
    }
}

// MARK: - Change Type

extension EntryController {
    typealias ChangeType = NSFetchedResultsChangeType
}

