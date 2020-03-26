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
        fetchEntriesFromServer()
    }
    
    func fetchEntriesFromServer(completion: (() -> Void)? = nil) {
        firebaseClient.fetchEntriesFromServer { result in
            switch result {
            case .failure(let error):
                print("Failed to fetch entries from server: \(error)")
            case .success(let representations):
                try? self.updateEntries(with: representations)
            }
            
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
    
    // MARK: - CRUD
    
    @discardableResult
    func createEntry(title: String, bodyText: String?, mood: Mood) -> Entry {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        firebaseClient.sendEntryToServer(entry) { error in
            if let error = error {
                NSLog("Error sending entry to server: \(error)")
            }
        }
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving moc after creating entry")
        }
        
        return entry
    }
    
    func update(_ entry: Entry, title: String, bodyText: String?, mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        firebaseClient.sendEntryToServer(entry) { error in
            if let error = error {
                NSLog("Error sending entry to server: \(error)")
            }
        }
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving moc after updating entry")
        }
    }
    
    func delete(_ entry: Entry) {
        // We should always delete the entry locally, regardless of whether we are online
        CoreDataStack.shared.mainContext.delete(entry)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving moc after deleting entry")
        }
        
        // Then we should attempt to delete from the server
        firebaseClient.deleteEntryFromServer(entry) { error in
            if let error = error {
                NSLog("Unable to delete entry from firebase: \(error)")
                // What should we do if the entry isn't delted from the server?
                // It would potentially be re-fetched from firebase...
                // Maybe we could make a list of entry ids that have been deleted locally but not remotely
                // Then when we sync with firebase, we could reference that list to determine which entries need to be deleted from the server
            }
        }
    }
    
    
    // MARK: - Syncing
    
    private func updateEntries(with entryReps: EntryRepsByID) throws {
        let entriesOnServerRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        entriesOnServerRequest.predicate = NSPredicate(format: "identifier IN %@", Array(entryReps.keys))
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.performAndWait {
            do {
                let existingEntries = try context.fetch(entriesOnServerRequest)
                var entriesToCreate = entryReps
                
                for entry in existingEntries {
                    let id = entry.identifier
                    guard let representation = entryReps[id] else { continue }
                    
                    // Check the timestamps for difference
                    switch entry.timestamp.distance(to: representation.timestamp) {
                    case ..<0:
                        // If the representation is older, we should send the local entry to the server
                        // We won't worry about if it doesn't succeed, though it should since we just fetched the entry reps
                        firebaseClient.sendEntryToServer(entry)
                    case 0:
                        // If they have the same timestamp, maybe we should check to see if they are different
                        // They shouldn't be though, unless the entry was modified without updating the timestamp...
                        break
                    default:
                        // If the representation is newer, we should update our local entry
                        update(entry, with: representation)
                    }
                    
                    entriesToCreate.removeValue(forKey: id)
                }
                
                for representation in entriesToCreate.values {
                    Entry(representation, context: context)
                }
            } catch {
                NSLog("Unable to fetch existing entries: \(error)")
            }
        }
    
        try CoreDataStack.shared.save(context: context)
        
        // Send entries that aren't on server
        let entriesNotOnServerRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        entriesOnServerRequest.predicate = NSPredicate(format: "!(identifier IN %@)", Array(entryReps.keys))
        
        context.perform {
            do {
                let entriesNotOnServer = try context.fetch(entriesNotOnServerRequest)
                for entry in entriesNotOnServer {
                    self.firebaseClient.sendEntryToServer(entry)
                }
            } catch {
                NSLog("Unable to fetch entries not on server: \(error)")
            }
        }
    }
    
    private func update(_ entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.moodString = representation.moodString
        entry.timestamp = representation.timestamp
        entry.identifier = representation.identifier
    }
}

