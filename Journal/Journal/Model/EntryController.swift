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
                try? self.syncEntries(with: representations)
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
        deleteFromServer(entry.identifier)
        
        CoreDataStack.shared.mainContext.delete(entry)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving moc after deleting entry")
        }
    }
    
    
    // MARK: - Private
    
    private func deleteFromServer(_ entryID: String) {
        firebaseClient.deleteEntryWithID(entryID) { error in
            if let error = error {
                NSLog("Unable to delete entry from firebase: \(error)")
                self.deleteLog.append(entryID)
            }
        }
    }
    
    private let deleteLogURL: URL = {
        let documentsDirctory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirctory.appendingPathComponent("deleteLog")
    }()
    
    private var deleteLog: [String] {
        get {
            do {
                let deleteLogData = try Data(contentsOf: deleteLogURL)
                let deleteLog = try JSONDecoder().decode([String].self, from: deleteLogData)
                return deleteLog
            } catch {
                return [String]()
            }
        }
        set {
            do {
                let newValueData = try JSONEncoder().encode(newValue)
                try newValueData.write(to: deleteLogURL)
            } catch {
                NSLog("Unable to save delete log: \(error)")
            }
        }
    }
    
    
    // MARK: - Syncing
    
    private func syncEntries(with entryReps: EntryRepsByID) throws {
        let entriesOnServerRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        entriesOnServerRequest.predicate = NSPredicate(format: "identifier IN %@", Array(entryReps.keys))
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.performAndWait {
            do {
                // First check for existing local entries matching Firebase representations
                let existingEntries = try context.fetch(entriesOnServerRequest)
                var entriesToCreate = entryReps
                
                for entry in existingEntries {
                    let id = entry.identifier
                    guard let representation = entryReps[id] else { continue }
                    
                    switch entry.timestamp.distance(to: representation.timestamp) {
                    case ..<0:
                        // If the Firebase representation is older, we should send the local entry to the server
                        firebaseClient.sendEntryToServer(entry)
                    case 0:
                        break
                    default:
                        // If the Firebase representation is newer, we should update our local entry
                        update(entry, with: representation)
                    }
                    
                    entriesToCreate.removeValue(forKey: id)
                }
                
                // Check to see if deleteLog has IDs of deleted entries that weren't propogated to Firebase
                for id in deleteLog {
                    entriesToCreate.removeValue(forKey: id)
                    deleteFromServer(id)
                }
                deleteLog = []
                
                // Create new entries from remaining Firebase representations
                for representation in entriesToCreate.values {
                    Entry(representation, context: context)
                }
            } catch {
                NSLog("Unable to fetch existing entries: \(error)")
            }
        }
    
        try CoreDataStack.shared.save(context: context)
        
        // Send entries that aren't on server up to server
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

