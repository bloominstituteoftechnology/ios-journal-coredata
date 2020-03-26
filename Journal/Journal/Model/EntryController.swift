//
//  EntryController.swift
//  Journal
//
//  Created by Shawn Gee on 3/23/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation
import CoreData

typealias EntryRepsByID = [String: EntryRepresentation]

class EntryController {
    
    // MARK: - Properties
    
    private let firebaseClient = FirebaseClient()
    
    
    // MARK: - Init
    
    init() {
        firebaseClient.fetchEntriesFromServer { result in
            switch result {
            case .failure(let error):
                print("Failed to fetch entries from server: \(error)")
            case .success(let representations):
                try? self.updateEntries(with: representations)
            }
        }
    }
    
    // MARK: - CRUD
    
    var entries: [Entry] {
        loadFromPersistentStore()
    }
    
    @discardableResult
    func createEntry(title: String, bodyText: String?, mood: Mood) -> Entry {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        firebaseClient.sendEntryToServer(entry)
        saveToPersistentStore()
        return entry
    }
    
    func update(_ entry: Entry, title: String, bodyText: String?, mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        firebaseClient.sendEntryToServer(entry)
        saveToPersistentStore()
    }
    
    func delete(_ entry: Entry) -> Error? {
        CoreDataStack.shared.mainContext.delete(entry)
        firebaseClient.deleteEntryFromServer(entry)
        return saveToPersistentStore()
    }
    
    
    // MARK: - Persistence
    
    private func loadFromPersistentStore() -> [Entry] {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            let entries = try CoreDataStack.shared.mainContext.fetch(request)
            return entries
        } catch {
            NSLog("Error fetching Entry objects from main context: \(error)")
            return []
        }
    }
    
    @discardableResult
    private func saveToPersistentStore() -> Error? {
        do {
            try CoreDataStack.shared.mainContext.save()
            return nil
        } catch {
            NSLog("Error saving core data main context: \(error)")
            return error
        }
    }
    
    
    // MARK: - Syncing
    
    private func updateEntries(with entryReps: EntryRepsByID) throws {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", Array(entryReps.keys))
        let context = CoreDataStack.shared.mainContext
        
        let existingEntries = try context.fetch(fetchRequest)
        var entriesToCreate = entryReps
        
        for entry in existingEntries {
            let id = entry.identifier
            guard let representation = entryReps[id] else { continue }
            update(entry, with: representation)
            entriesToCreate.removeValue(forKey: id)
        }
        
        for representation in entriesToCreate.values {
            Entry(representation)
        }
        
        saveToPersistentStore()
    }
    
    private func update(_ entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.moodString = representation.moodString
        entry.timestamp = representation.timestamp
        entry.identifier = representation.identifier
    }
}
