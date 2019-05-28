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

    func saveToPersistentStore() {

        do{
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Could Not save data to persistent Stores: \(error)")
        }
    }

    func createEntry(title: String, bodyText: String, mood: String) {

        _ = Entry(title: title, bodyText: bodyText, mood: mood)

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

        let moc = CoreDataStack.shared.mainContext

        moc.delete(entry)
        saveToPersistentStore()
    }

}
