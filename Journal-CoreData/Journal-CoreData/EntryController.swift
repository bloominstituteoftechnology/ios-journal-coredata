//
//  EntryController.swift
//  Journal-CoreData
//
//  Created by Jerrick Warren on 11/7/18.
//  Copyright © 2018 Jerrick Warren. All rights reserved.
//

import Foundation
import CoreData

class EntryController {

    // CRUD Methods here
    
    
func saveToPersistentStore() {
    let moc = CoreDataStack.shared.mainContext
    do {
        try moc.save()
    } catch {
        NSLog("Error savivng managed object context:\(error) to file")
    }
}


    // this will return an array
func loadFromPersistentStore() -> [Entry] {
   let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
    
    let moc = CoreDataStack.shared.mainContext
    do {
        return try moc.fetch(fetchRequest)
    } catch {
        NSLog("Error fetching tasks: \(error)")
        return []
    }

}



// MARK: - Properties

    var entries: [Entry] = []

}
