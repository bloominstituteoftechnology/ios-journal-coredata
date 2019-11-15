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
    lazy private var syncController: SyncController = {
        let syncController = SyncController()
        return syncController
    }()
    
    var delegate: CoreDataStackDelegate? {
        get {
            return coreDataStack.delegate
        } set {
            coreDataStack.delegate = newValue
        }
    }
    
    typealias ChangeType = NSFetchedResultsChangeType
    typealias FetchRequest = NSFetchRequest<Entry>
    
    // MARK: - Init
    
    override init() {
        super.init()
        syncAllEntries()
    }
    
    // MARK: - Sync
    
    func syncAllEntries(completion: @escaping CompletionHandler = { _ in }) {
        syncController.fetchEntriesFromServer { error, entryRepresentations in
            if let error = error {
                print("Error fetching entries from server: \(error)")
                completion(error)
            }
            guard let entryReps = entryRepresentations else {
                print("Error; no entry representations received.")
                completion(nil)
                return
            }
            self.updateLocalEntries(from: entryReps)
            self.updateServerEntries(using: entryReps)
            completion(nil)
        }
    }
    
    private func updateLocalEntries(from serverRepresentations: [Entry.Representation]) {
        // This method is called from a network completion closure,
        // so a background context must be used.
        let backgroundContext = coreDataStack.container.newBackgroundContext()
        
        var error: Error?
        // Wait in case of error; then, if caught, handle it
        backgroundContext.performAndWait {
            let idsToFetch = serverRepresentations.compactMap { $0.identifier }
            let representationsByID = Dictionary(
                uniqueKeysWithValues: zip(idsToFetch, serverRepresentations)
            )
            var entriesToCreate = representationsByID
            
            let fetchRequest: FetchRequest = Entry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", idsToFetch)
            do {
                let existingEntries = try fetch(request: fetchRequest, with: backgroundContext)
                for entry in existingEntries {
                    guard let id = entry.identifier,
                        let representation = representationsByID[id]
                        else { continue }
                    update(entry: entry, from: representation)
                    entriesToCreate.removeValue(forKey: id)
                }
                for representation in entriesToCreate.values {
                    Entry(representation: representation, context: backgroundContext)
                }
                try coreDataStack.save(in: backgroundContext)
            } catch let updateError {
                error = updateError
            }
        }
        if let caughtError = error {
            print("Error updating tasks from server: \(caughtError)")
        }
    }
    
    private func updateServerEntries(using serverEntryReps: [Entry.Representation]) {
        // send local entries that aren't on server
        let idsOnServer = serverEntryReps.map { rep -> String in
            return rep.identifier
        }
        let context = self.coreDataStack.container.newBackgroundContext()
        context.perform {
            let request: NSFetchRequest<Entry> = Entry.fetchRequest()
            request.predicate = NSPredicate(format: "NOT (identifier IN %@)", idsOnServer)
            guard let entriesToSend: [Entry] = try? context.fetch(request) else {
                print("Error fetching unsynced entries")
                return
            }
            for entry in entriesToSend {
                if let rep = entry.representation,
                    serverEntryReps.contains(rep) {
                    entry.handleBadID()
                    self.syncController.sendToServer(entry: entry)
                }
            }
        }
    }
    
    // MARK: - CRUD
    
    func create(entryWithTitle title: String, body: String, mood: Entry.Mood) {
        let context = coreDataStack.mainContext
        let entry = Entry(
            title: title,
            bodyText: body,
            mood: mood,
            context: context
        )
        do {
            try coreDataStack.save(in: context)
        } catch {
            print("Error creating entry: \(error)")
        }
        syncController.sendToServer(entry: entry)
    }
    
    func update(entry: Entry, withNewTitle title: String, body: String, mood: Entry.Mood) {
        entry.title = title
        entry.bodyText = body
        entry.mood = mood.rawValue
        do {
            try coreDataStack.save(in: coreDataStack.mainContext)
        } catch {
            print("Error creating entry: \(error)")
        }
        syncController.sendToServer(entry: entry)
    }
    
    func update(entry: Entry, from representation: Entry.Representation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
        entry.identifier = representation.identifier
    }
    
    func delete(entry: Entry) {
        coreDataStack.mainContext.delete(entry)
        syncController.deleteEntryFromServer(entry)
        do {
            try coreDataStack.save(in: coreDataStack.mainContext)
        } catch {
            print("Error deleting entry: \(error)")
            return
        }
    }
    
    // MARK: - TableView API
    
    func fetch(entryAt indexPath: IndexPath) -> Entry? {
        return coreDataStack.fetchedResultsController.object(at: indexPath)
    }
    
    func fetch(request: FetchRequest, with context: NSManagedObjectContext) throws -> [Entry] {
        return try context.fetch(request)
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
    
    func fetchAllEntriesFromLocalStore(with context: NSManagedObjectContext) -> [Entry] {
        let request = NSFetchRequest<Entry>()
        var entries: [Entry]?
        context.perform {
            do {
                entries = try context.fetch(request)
            } catch {
                print("Error fetching all entries: \(error)")
            }
        }
        return entries ?? []
    }
    
    // helper computed property for TableView API
    private var fetchedResultsAreEmpty: Bool {
        guard let array = coreDataStack.fetchedResultsController.fetchedObjects
            else { return true }
        return array.isEmpty
    }
}
