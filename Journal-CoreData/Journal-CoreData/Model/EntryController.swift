//
//  EntryController.swift
//  Journal-CoreData
//
//  Created by Nikita Thomas on 11/5/18.
//  Copyright © 2018 Nikita Thomas. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//    }
    
    func saveToPersistenceStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
          try moc.save()
        } catch {
            NSLog("Could not save to disk: \(error)")
        }
    }
    
//    func loadFromPersistentStore() -> [Entry] {
//        let moc = CoreDataStack.shared.mainContext
//        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
//
//        // Same way of doing it I think
//        // let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//
//        do {
//            return try moc.fetch(fetchRequest)
//        } catch {
//            NSLog("Error fetching tasks: \(error)")
//            return []
//        }
//    }
    func newEntry(title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        
        saveToPersistenceStore()
        put(entry: entry)
    }
    
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.setValue(title, forKey: "title")
        entry.setValue(bodyText, forKey: "bodyText")
        entry.setValue(Date(), forKey: "timeStamp")
        entry.setValue(mood, forKey: "mood")
        
        saveToPersistenceStore()
        put(entry: entry)
    }
    
    
    func deleteEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistenceStore()
    }
    
    let baseURL: URL = URL(string: "https://iojournal-9ad15.firebaseio.com/")!
    
    func put(entry: Entry, completion: @escaping (_ error: Error?) -> Void = { _ in }) {
        guard let identifier = entry.identifier else {fatalError("entry doesn't have identifier")}
        
        var request = URLRequest(url: baseURL.appendingPathComponent(identifier).appendingPathExtension("json"))
        request.httpMethod = "PUT"

        do {
            let data = try JSONEncoder().encode(entry)
            request.httpBody = data
        } catch {
            NSLog("Error enconding data: \(error)")
            completion(error)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error creating database: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }
        dataTask.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (_ error: Error?) -> Void = { _ in }) {
        guard let identifier = entry.identifier else {fatalError("entry doesn't have identifier")}
        
        
        var request = URLRequest(url: baseURL.appendingPathComponent(identifier).appendingPathExtension("json"))
        request.httpMethod = "DELETE"
        
        print(request)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error creating datatask: \(error)")
                completion(error)
                return
            }
            completion(nil)
            return
        }
        dataTask.resume()
    }
    
    
    //MARK: - Syncing database
    
    func update(entry: Entry, stub: EntryStub) {
        entry.title = stub.title
        entry.bodyText = stub.bodyText
        entry.timeStamp = stub.timeStamp
        entry.mood = stub.mood
        entry.identifier = stub.identifier
    }
    
    func fetchSingleEntryFromPersistentStore(identifier: String) -> Entry? {
        let moc = CoreDataStack.shared.mainContext
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        do {
            return try moc.fetch(fetchRequest)[0]
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return nil
        }
    }
    
    func fetchEntriesFromServer( completion: @escaping (_ error: Error?) -> Void = { _ in }) {
        let url = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {data, _, error in
            if let error = error {
                NSLog("Error creating dataTask: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data: \(String(describing: error))")
                completion(error)
                return
            }
            
            var stubs: [EntryStub] = []
            
            let decoder = JSONDecoder()
            do {
                let json = try decoder.decode([String: EntryStub].self, from: data)
                for (_, entry) in json {
                    stubs.append(entry)
                }
                
            } catch {
                NSLog("Couldnt decode json into stubs:\(error)")
                completion(error)
                return
            }
            
            for stub in stubs {
                let entry = self.fetchSingleEntryFromPersistentStore(identifier: stub.identifier)
                if entry != nil {
                    // Have an entry matching identifier on server + persistence
                    if entry! != stub {
                     // Data mistmach. Need to update persistence store
                        self.update(entry: entry!, stub: stub)
                    }
                } else {
                    _ = Entry(stub: stub)
                }
            }
            self.saveToPersistenceStore()
            completion(nil)
        }
        dataTask.resume()
    }
    
    
    
    init() {
        fetchEntriesFromServer { (error) in
            if let error = error {
                NSLog("error fetching from server: \(error)")
                return
            }
        }
    }
    
    
}
