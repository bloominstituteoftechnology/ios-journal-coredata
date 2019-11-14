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
    
    internal var coreDataStack = CoreDataStack()
    lazy private var syncController: SyncController = {
        let syncController = SyncController()
        syncController.delegate = self
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
        syncController.fetchEntriesFromServer()
    }
    
    // MARK: - CRUD
    
    func create(entryWithTitle title: String, body: String, mood: Entry.Mood) {
        let entry = Entry(
            title: title,
            bodyText: body,
            mood: mood,
            context: coreDataStack.context
        )
        saveToLocalPersistentStore()
        syncController.putToServer(entry: entry)
    }
    
    func update(entry: Entry, withNewTitle title: String, body: String, mood: Entry.Mood) {
        entry.title = title
        entry.bodyText = body
        entry.mood = mood.rawValue
        saveToLocalPersistentStore()
        syncController.putToServer(entry: entry)
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
        syncController.deleteEntryFromServer(entry)
        saveToLocalPersistentStore()
    }
    
    // MARK: - Local Storage
    
    private var fetchedResultsAreEmpty: Bool {
        guard let array = coreDataStack.fetchedResultsController.fetchedObjects
            else { return true }
        return array.isEmpty
    }
    
    func fetch(entryAt indexPath: IndexPath) -> Entry? {
        return coreDataStack.fetchedResultsController.object(at: indexPath)
    }
    
    func fetch(request: FetchRequest) throws -> [Entry] {
        return try coreDataStack.context.fetch(request)
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
    
    func saveToLocalPersistentStore() {
        let moc = coreDataStack.context
        do {
            try moc.save()
        } catch {
            print("Error saving journal entries: \(error)")
        }
    }
    
    internal func fetchAllEntriesFromLocalStore() -> [Entry] {
        guard let entries = coreDataStack.fetchedResultsController.fetchedObjects else {
            return []
        }
        return entries
    }
}

// MARK: - Sync Controller Delegate

extension EntryController: SyncControllerDelegate {}
