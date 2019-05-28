//
//  EntryController.swift
//  Journal
//
//  Created by Christopher Aronson on 5/27/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import CoreData

class EntryController {

    func saveToPersistentStore() {

        do{
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Could Not save data to persistent Stores: \(error)")
        }
    }

    func loadFromPersistentStore() -> [Entry] {

        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()

        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Could not load data from persistent store: \(error)")
            return []
        }
    }
}
