//
//  EntryController.swift
//  Journal
//
//  Created by Lydia Zhang on 3/23/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}
class EntryController {

    init() {
        fetchEntriesFromServer()
    }
    
    let baseURL: URL = URL(string: "https://journal-54160.firebaseio.com/")!
    typealias CompletionHandler = (Error?) -> ()
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {return}
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        let jsonEncoder = JSONEncoder()
        do {
            guard var representation = entry.entryRepresentation else {return}
            representation.identifier = uuid
            try moc.save()
            request.httpBody = try jsonEncoder.encode(representation)
        } catch {
            NSLog("encoding error")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _ , error ) in
            guard error == nil else {
                NSLog("put error")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {return}
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            guard error == nil else {
                NSLog("delete error")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    let moc = CoreDataStack.shared.mainContext
    
    func saveToPersistentStore() {
        do {
            try moc.save()
        } catch {
            NSLog("Saving error: \(error)")
        }
        
    }
    
    func create(title: String, bodyText: String, mood: Mood) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
        saveToPersistentStore()
    }
    func update(entry: Entry, entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText ?? ""
        entry.timestamp = entryRepresentation.timestamp 
        entry.mood = entryRepresentation.mood.rawValue
        
    }
    func updateLocal(entry: Entry, title: String, bodyText: String, mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        saveToPersistentStore()
    }
    func updateEntries(with representations: [EntryRepresentation]) {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let hasID = representations.map { $0.identifier }
        var sortedByID = Dictionary(uniqueKeysWithValues: zip(hasID, representations))
        
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", sortedByID)
        do {
            let exist = try moc.fetch(fetchRequest)
            for entry in exist {
                guard let identifier = entry.identifier,
                    let representation = sortedByID[identifier] else {return}
                update(entry: entry, entryRepresentation: representation)
                sortedByID.removeValue(forKey: identifier)
            }
            for notExist in sortedByID.values {
                Entry(entryRepresentation: notExist)
            }
            try moc.save()
        } catch {
            NSLog("sync error")
            return
        }
        
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> () = { _ in }) {
        let requesURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requesURL) { (data, _, error) in
            guard error == nil else {
                NSLog("fetch error")
                completion(NSError())
                return
            }
            guard let data = data else {
                NSLog("no fetch data")
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let representations = try jsonDecoder.decode([String: EntryRepresentation].self, from: data)
                let representationsValueArray = Array(representations.values)
                self.updateEntries(with: representationsValueArray)
                completion(nil)
            } catch {
                NSLog("decode error")
                completion(error)
            }
        }.resume()
    }
    
    func delete(entry: Entry) {
        moc.delete(entry)
        deleteEntryFromServer(entry: entry)
        saveToPersistentStore()
    }
}
