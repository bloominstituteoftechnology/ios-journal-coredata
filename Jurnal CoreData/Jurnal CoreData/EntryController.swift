//
//  EntryController.swift
//  Jurnal CoreData
//
//  Created by Sergey Osipyan on 1/21/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    func saveToPersistentStore() {
        
        do {
          try CoreDataStack.shared.mainContext.save()
        } catch {
            fatalError("Can;t save Data \(error)")
        }
      
    }
//
//    func loadFromPersistentStore() -> [Entry] {
//        var entry: [Entry] {
//        do {
//            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//            let resualt = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
//             return resualt
//        }catch {
//             fatalError("Can;t fetch Data \(error)")
//        }
//    }
//        return entry
//}
//    
//    var entries: [Entry] {
//        let resualt = loadFromPersistentStore()
//        return resualt
//    }
    
    func create(title: String, bodyText: String, mood: String) {
        
        let newEntry = Entry(context: CoreDataStack.shared.mainContext)
        
        newEntry.bodyText = bodyText
        newEntry.title = title
        newEntry.mood = mood
        newEntry.timestamp = Date()
        newEntry.identifier = "\(UUID.self)"
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
}
