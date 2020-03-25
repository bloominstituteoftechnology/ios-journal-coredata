//
//  EntryRepresentation.swift
//  journal-coredata
//
//  Created by Karen Rodriguez on 3/25/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import Foundation
import CoreData

struct EntryRepresentation: Codable {
    var identifier: String
    var title: String
    var bodyText: String?
    var timestamp: Date
    var mood: String
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText ?? ""
        entry.mood = entryRepresentation.mood
        entry.timestamp = entryRepresentation.timestamp
    }
    
    func updateEntries(with representations: [EntryRepresentation]) {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        // creating a brand new array that only consists of the identifiers from the passed in representations array
        let representationsIdentifiers = representations.map { $0.identifier }
        
        let representationsById = Dictionary(uniqueKeysWithValues: zip(representationsIdentifiers, representations))
        
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", representationsById)
        
        var context = CoreDataStack.shared.mainContext
        
        do {
            let existingTasks = try context.fetch(fetchRequest)
        } catch {
            
        }
        
        
    }
}
