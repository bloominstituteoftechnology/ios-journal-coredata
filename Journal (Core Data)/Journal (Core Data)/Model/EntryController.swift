//
//  EntryController.swift
//  Journal (Core Data)
//
//  Created by David Wright on 2/12/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-693f9.firebaseio.com/")!

class EntryController {
        
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - CRUD Methods

    // Create Entry
    func createEntry(withTitle title: String, bodyText: String, mood: String) {
        Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
    }
    
    // Update Entry
    func updateEntry(_ entry: Entry, updatedTitle: String, updatedBodyText: String, updatedMood: String) {
        let updatedTimestamp = Date()
        entry.title = updatedTitle
        entry.bodyText = updatedBodyText
        entry.timestamp = updatedTimestamp
        entry.mood = updatedMood
        saveToPersistentStore()
    }
    
    // Delete Entry
    func deleteEntry(_ entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
    
    // MARK: - Persistence

    private func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving to persistent store: \(error)")
        }
    }
}
