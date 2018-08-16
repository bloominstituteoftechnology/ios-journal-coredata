//
//  EntryController.swift
//  ios-journal-coredata
//
//  Created by Conner on 8/13/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation
import CoreData

let baseURL: URL = URL(string: "https://journalapp-acf5b.firebaseio.com/")!

class EntryController {
    init() {
        fetchEntriesFromServer()
    }

    typealias CompletionHandler = (Error?) -> Void

    func update(entry: Entry, entryRep: EntryRepresentation) {
        entry.bodyText = entryRep.bodyText
        entry.identifier = entryRep.identifier
        entry.title = entryRep.title
        entry.timestamp = entryRep.timestamp
        entry.mood = entryRep.mood
    }

    func fetchSingleEntryFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Entry? {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == %@", identifier)
        do {
            return try context.fetch(request).first
        } catch {
            NSLog("Error fetching entry with identifier: \(identifier) - \(error)")
            return nil
        }
    }

    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let url = baseURL.appendingPathExtension("json")

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error with GETting data: \(error)")
                completion(error)
                return
            }

            guard let data = data else {
                NSLog("No data returned by data task")
                completion(NSError())
                return
            }

            var entryRepresentations: [EntryRepresentation] = []

            do {
                let decoder = JSONDecoder()
                let jsonEntries = try decoder.decode([String: EntryRepresentation].self, from: data)
                entryRepresentations = jsonEntries.values.map { $0 }

                let backgroundMOC = CoreDataManager.shared.container.newBackgroundContext()
                try self.updateEntriesFromServer(with: entryRepresentations, context: backgroundMOC)
                completion(nil)
            } catch let error {
                NSLog("Error decoding data: \(error)")
            }


        }.resume()
    }

    func updateEntriesFromServer(with entryRepresentations: [EntryRepresentation], context: NSManagedObjectContext) throws {
        var error: Error?

        context.performAndWait {
            for entryRep in entryRepresentations {
                if let entry = self.fetchSingleEntryFromPersistentStore(identifier: entryRep.identifier, context: context) {
                    if !(entry == entryRep) {
                        self.update(entry: entry, entryRep: entryRep)
                    }
                } else {
                    let _ = Entry(entryRepresentation: entryRep, managedObjectContext: context)
                }
            }

            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }

        if let error = error {
            throw error
        }
    }

    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let identifier = entry.identifier ?? UUID().uuidString
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"

        do {
            let encoder = JSONEncoder()
            urlRequest.httpBody = try encoder.encode(entry)
        } catch {
            NSLog("Error with encoding entry: \(error)")
        }

        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                NSLog("Error with PUTting data: \(error)")
                completion(error)
                return
            }

            completion(nil)
        }.resume()
    }

    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let identifier = entry.identifier ?? UUID().uuidString
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                NSLog("Could not delete \(entry) from server: \(error)")
                completion(error)
                return
            }

            completion(nil)
        }.resume()
    }

    func createEntry(title: String,
        identifier: String,
        timestamp: Date = Date(),
        bodyText: String,
        mood: String) {

        guard let mood = Mood(rawValue: mood) else { return }
        let entry = Entry(title: title,
            identifier: identifier,
            timestamp: timestamp,
            bodyText: bodyText,
            mood: mood)
        self.put(entry: entry)
    }

    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) throws {
        let moc = CoreDataManager.shared.mainContext

        var error: Error?

        moc.performAndWait {
            entry.title = title
            entry.bodyText = bodyText
            entry.timestamp = Date()
            entry.mood = mood

            do {
                self.put(entry: entry)
                try moc.save()
            } catch let saveError {
                error = saveError
            }
        }

        if let error = error {
            throw error
        }
    }

    func deleteEntry(entry: Entry) throws {
        let moc = CoreDataManager.shared.mainContext

        var error: Error?

        moc.performAndWait {
            moc.delete(entry)
            deleteEntryFromServer(entry: entry)

            do {
                try moc.save()
            } catch let saveError {
                error = saveError
            }
        }

        if let error = error {
            throw error
        }
    }
}
