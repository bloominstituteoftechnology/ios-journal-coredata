//
//  EntryController.swift
//  Journal
//
//  Created by Jake Connerly on 8/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Enums

enum HTTPMethod: String {
    case get    = "GET"
    case put    = "PUT"
    case post   = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError(Error)
    case badData
    case noDecode
}

class EntryController {
    
    let baseURL = URL(string: "https://journal-5ee58.firebaseio.com/")!
    
    // MARK: - CRUD Methods
    
    // Create
    func createEntry(with title: String, bodyText: String, timeStamp: Date, mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            let entry = Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, mood: mood)
            do{
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context when creating new task :\(error)")
            }
            put(entry: entry)
        }
    }
    
    // Update
    func updateEntry(entry: Entry, with title: String, bodyText: String, timeStamp: Date, mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            entry.title     = title
            entry.bodyText  = bodyText
            entry.timeStamp = timeStamp
            entry.mood      = mood.rawValue
            
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context when updating entry:\(error)")
            }
            put(entry: entry)
        }
    }
    
    // Update Entry with Entry Representation Method
    func update(entry: Entry, with entryRepresentation: EntryRepresentation) {
        entry.title      = entryRepresentation.title
        entry.timeStamp  = entryRepresentation.timeStamp
        entry.mood       = entryRepresentation.mood
        entry.identifier = entryRepresentation.identifier
        entry.bodyText   = entryRepresentation.bodyText
    }
    
    // Delete
    func deleteEntry(entry: Entry, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        deleteEntryFromServer(entry: entry)
        context.performAndWait {
            context.delete(entry)
            
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context when deleting entry:\(error)")
            }
        }
    }
}

// MARK: - Extensions

extension EntryController {
    
    func updatePersistentStore(forTasksIn entryRepresentations: [EntryRepresentation], for context: NSManagedObjectContext) {
        context.performAndWait {
            
            for entryRep in entryRepresentations {
                guard let identifier = entryRep.identifier else { continue }
                
                if let entry = self.fetchSingleEntryFromPersistentStore(identifier: identifier, context: context) {
                    entry.title      = entryRep.title
                    entry.timeStamp  = entryRep.timeStamp
                    entry.mood       = entryRep.mood
                    entry.identifier = entryRep.identifier
                    entry.bodyText   = entryRep.bodyText
                } else {
                    Entry(entryRepresentation: entryRep, context: context)
                }
            }
            
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context: \(error)")
                context.reset()
            }
        }
    }
}
