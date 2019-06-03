//
//  EntryController.swift
//  Journal
//
//  Created by Jonathan Ferrer on 6/3/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation
import CoreData

class EntryController {

    func createEntry(title: String, bodyText: String) {
        _ = Entry(title: title, timeStamp: Date(), bodyText: bodyText)
        saveToPersistentStore()
    }

    func updateEntry(entry: Entry, title: String, bodyText: String) {

        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = Date()

        saveToPersistentStore()
    }

    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)

        do {
            try moc.save() 

        } catch {
            moc.reset()
            NSLog("Error saving managed object content \(error)")
        }

    }


    func loadFromPersistentStore() -> [Entry] {

        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
        } catch  {
            NSLog("Error fetching tasks: \(error)")
            return []
        }

    }

    func saveToPersistentStore() {

        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object contex: \(error)")
        }
    }

    var entries: [Entry] {
        let loadedData = loadFromPersistentStore()
        return loadedData
    }


}
