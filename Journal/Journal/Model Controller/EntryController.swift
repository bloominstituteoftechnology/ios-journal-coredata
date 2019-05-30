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

enum HTTPMethod: String {
    case PUT
    case GET
    case POST
    case DELETE
}

class EntryController {
    //MARK: - Properties
    let baseURL = URL(string: "https://journal-e4be9.firebaseio.com/")!

    init() {

        fetchEntriesFromServer { _ in
            
        }
    }

    // MARK: - CRUD Methods
    func saveToPersistentStore() {

        do{
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Could Not save data to persistent Stores: \(error)")
        }
    }

    func createEntry(title: String, bodyText: String, mood: String) {

        let entry = Entry(title: title, bodyText: bodyText, mood: mood)

        saveToPersistentStore()

        put(entry: entry) {

        }
    }

    func update(entry: Entry, title: String, bodyText: String, mood: String) {

        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()

        saveToPersistentStore()
        put(entry: entry) {

        }
    }

    func delete(entry: Entry) {

        delete(entry: entry) { _ in

        }

        let moc = CoreDataStack.shared.mainContext

        moc.delete(entry)
        saveToPersistentStore()
    }

    //MARK: - HTTP Methods
    func put(entry: Entry, completion: @escaping () -> Void) {

        let requestURL = baseURL
            .appendingPathComponent(entry.identifier ?? UUID().uuidString)
            .appendingPathExtension("json")

        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.PUT.rawValue

        do{
            try request.httpBody = JSONEncoder().encode(entry)
        } catch {
            NSLog("Could not encode entry to json: \(error)")
        }

        URLSession.shared.dataTask(with: request) { (_, _, error) in

            if let error = error {
                NSLog("Could not PUT data: \(error)")
                completion()
                return
            }

            completion()
        }.resume()
    }

    func delete(entry: Entry, completion: @escaping (Error?) -> Void) {

        let requestURL = baseURL
            .appendingPathComponent(entry.identifier ?? UUID().uuidString)
            .appendingPathExtension("json")

        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.DELETE.rawValue

        URLSession.shared.dataTask(with: request) { (_, _, error) in

            if let error = error {
                NSLog("Could not get connect to database to delete: \(error)")
                completion(error)
                return
            }

            completion(nil)
        }.resume()
    }

    func update(entry: Entry, entryRepesentation: EntryRepresentation) {

        entry.title = entryRepesentation.title
        entry.bodyText = entryRepesentation.bodyText
        entry.mood = entryRepesentation.mood
        entry.timestamp = entryRepesentation.timestamp
        entry.identifier = entryRepesentation.identifier
    }

    func fetchSingleEntryFromPersistentStore(identifier: String) -> Entry? {

        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)

        do {
            return try CoreDataStack.shared.mainContext.fetch(fetchRequest).first
        } catch {
            return nil
        }
    }

    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void){

        let requestURL = baseURL
            .appendingPathExtension("json")

        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.GET.rawValue

        URLSession.shared.dataTask(with: request) { (data, _, error) in

            if let error = error {
                NSLog("Could not complete fetch from server: \(error)")
                completion(error)
                return
            }

            guard let data = data else {
                NSLog("Data not returned from server")
                completion(NSError(domain: "Data", code: 0, userInfo: nil))
                return
            }

            var entryRep: [EntryRepresentation] = []

            do {
                let entries = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                entryRep = Array(entries.values)

                for rep in entryRep {

                    let entry = self.fetchSingleEntryFromPersistentStore(identifier: rep.identifier)

                    if let returnedEntry = entry {
                        if returnedEntry != rep {
                            self.update(entry: returnedEntry, entryRepesentation: rep)
                        }
                    } else {
                        _ = Entry(entryRepresentation: rep)
                    }

                    self.saveToPersistentStore()

                    completion(nil)
                }

            } catch {
                NSLog("Error decoding TaskRepresentations and adding them to persistent store: \(error)")
                completion(error)
                return
            }
        }.resume()
    }

}
