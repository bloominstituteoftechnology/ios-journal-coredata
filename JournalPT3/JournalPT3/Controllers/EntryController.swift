//
//  EntryController.swift
//  JournalPT3
//
//  Created by Jessie Ann Griffin on 12/4/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    typealias CompletionHandler = (Error?) -> Void
    private let baseURL = URL(string: "https://journalpt3.firebaseio.com/")
    
    private let moc = CoreDataStack.shared.mainContext
    
//    var entries: [Entry] {
//        loadFromPersistentStore()
//    }
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let baseURL = baseURL else { return }
        let uuid = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = uuid
            entry.identifier = uuid
            try saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding entry \(entry): \(error)")
            completion(error)
            return
        }
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        
    }
    
    func createEntry(title: String, mood: EntryMood, bodyText: String?) {
        let entry = Entry(title: title, mood: mood, bodyText: bodyText)
        put(entry: entry)
//        try saveToPersistentStore()
    }
    
    func updateEntry(title: String, mood: EntryMood = .normal, bodyText: String?, entry: Entry) {
        entry.title = title
        entry.mood = mood.rawValue
        entry.bodyText = bodyText
        entry.timestamp = Date()
        put(entry: entry)
//        try saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        moc.delete(entry)
//        try saveToPersistentStore()
    }
    
    private func saveToPersistentStore() throws {
        do {
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
//    private func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        do {
//            return try moc.fetch(fetchRequest)
//        } catch {
//            print("Error fetching tasks: \(error)")
//            return []
//        }
//    }
}
