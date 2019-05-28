//
//  EntryController.swift
//  Journal
//
//  Created by Christopher Aronson on 5/27/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case 😭
    case 😐
    case 😊
}

class EntryController {

    var entries: [Entry] {
        return loadFromPersistentStore()
    }


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

    func createEntry(title: String, bodyText: String, mood: String) {

        _ = Entry(title: title, bodyText: bodyText, mood: mood)

        saveToPersistentStore()
    }

    func update(entry: Entry, title: String, bodyText: String, mood: String) {

        guard let index = entries.firstIndex(of: entry) else { return }

        entries[index].title = title
        entries[index].bodyText = bodyText
        entries[index].timestamp = Date()
        entries[index].mood = mood

        saveToPersistentStore()
    }

    func delete(entry: Entry) {

        let moc = CoreDataStack.shared.mainContext

        moc.delete(entry)
        saveToPersistentStore()
    }

}
