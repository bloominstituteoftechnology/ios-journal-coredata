//
//  EntryController.swift
//  Journal
//
//  Created by brian vilchez on 10/15/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import Foundation
import CoreData
class EntryController {
    
    // MARK: - properties
    var entries: [Entry] = []
    
    // initializer
    init() {
        loadFromPersistenceStore()
    }
    
    
    //MARK: - methods
    private func loadFromPersistenceStore()  -> [Entry] {
        var entries:[Entry] {
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            let moc = CoreDataStack.shared.context
            do {
                let entries = try moc.fetch(fetchRequest)
                return entries
            } catch {
                NSLog("unable to fetch Entries: \(error.localizedDescription)")
                return []
            }
        }
        self.entries.append(contentsOf: entries)
        return entries
    }
    
    func createEntry(withTitle title: String, bodyText: String, context: NSManagedObjectContext) {
        let entry = Entry(title: title, bodyText: bodyText, context: context)
        entries.append(entry)
        CoreDataStack.shared.context.saveChanges()
    }
    
    func updateEntry(ForEntry entry: Entry, with title: String, bodyText: String) {
        entry.bodyText = bodyText
        entry.title = title
        CoreDataStack.shared.context.saveChanges()
        
    }
    
    func deleteEntry(_ entry: Entry) {
        CoreDataStack.shared.context.delete(entry)
        CoreDataStack.shared.context.saveChanges()
    }
    
}
