//
//  EntryController.swift
//  Journal (Core Data)
//
//  Created by Julian A. Fordyce on 2/18/19.
//  Copyright © 2019 Glas Labs. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        return loadFromPersistentStore()
    }
    
    
    func saveToPersistentStore(){
            let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            print("Error saving: \(NSError())")
        }
    }


    func loadFromPersistentStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching: \(NSError())")
            return []
        }
    }

    
    
    
    
    
}
