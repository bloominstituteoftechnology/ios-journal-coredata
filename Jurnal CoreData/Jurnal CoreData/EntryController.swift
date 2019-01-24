//
//  EntryController.swift
//  Jurnal CoreData
//
//  Created by Sergey Osipyan on 1/21/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    func saveToPersistentStore() {
        
        do {
          try CoreDataStack.shared.mainContext.save()
        } catch {
            fatalError("Can;t save Data \(error)")
        }
      
    }

//    func loadFromPersistentStore() -> [Entry] {
//        var entry: [Entry] {
//        do {
//            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//            let resualt = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
//             return resualt
//        }catch {
//             fatalError("Can;t fetch Data \(error)")
//        }
//    }
//        return entry
//}
//    
//    var entries: [Entry] {
//        let resualt = loadFromPersistentStore()
//        return resualt
//    }
    
    func create(title: String, bodyText: String, mood: String, identifier: String = UUID().uuidString) {
        
        let newEntry = Entry(context: CoreDataStack.shared.mainContext)
        
        newEntry.bodyText = bodyText
        newEntry.title = title
        newEntry.mood = mood
        newEntry.timestamp = Date()
        newEntry.identifier = identifier
        put(entry: newEntry)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String, identifier: String = UUID().uuidString) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        entry.identifier = identifier
        put(entry: entry)
        saveToPersistentStore()
    }
    func delete(entry: Entry) {
        deleteEntryFromServer(entry: entry)
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    
    typealias CompletionHandler = (Error?) -> Void
    
    private let baseURL = URL(string: "https://journal-b933b.firebaseio.com/")!
    var entryRepresentation: [EntryRepresentation] = []
    
    func put(entry: Entry, comletion: @escaping CompletionHandler = { _ in }){
        
      
//        guard let uuid = entry.identifier else { return }
//        print(uuid)
        let requestURL = baseURL.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
        
       print(requestURL)
            var request = URLRequest(url: requestURL)
            request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
        } catch {
            NSLog("Unable to encode \(entry): \(error)")
            comletion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("No fetching tasks \(error)")
                comletion(error)
            }
            }.resume()
    }
        func deleteEntryFromServer(entry: Entry, complition : @escaping CompletionHandler = {  _ in}) {
        
            let URL = baseURL.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
            
            var request = URLRequest(url: URL)
            request.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: request) { (_, _, error) in
                if let error = error {
                    NSLog("Errorsaving task \(error)")
                }
                complition(error)
                }.resume()
        }
    
    func updateEntry(ToEntry: Entry, fromEntryRepresentation: EntryRepresentation) {
       
        ToEntry.title = fromEntryRepresentation.title
        ToEntry.bodyText = fromEntryRepresentation.bodyText
        ToEntry.identifier = fromEntryRepresentation.identifier
        ToEntry.timestamp = fromEntryRepresentation.timestamp
        ToEntry.mood = fromEntryRepresentation.mood
        
    }
    
    func fetchSingleEntryFromPersistentStore(entryIdentifier: String) -> Entry? {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", entryIdentifier)
        fetchRequest.predicate = predicate
        
        let moc = CoreDataStack.shared.mainContext
        let entry = try? moc.fetch(fetchRequest)
       
        guard let requestedEntry = entry else {
            fatalError("Can't fetch Entry")
        }
            return requestedEntry.first
    }
    
    func fetchEntriesFromServer(complition: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
//        var request = URLRequest(url: requestURL)
//        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("No fetching tasks \(error)")
                complition(error)
                return
            }
            guard let data = data else {
                NSLog("No data")
                complition(NSError())
                return
            }
            
                do {
                    self.entryRepresentation = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map({$0.value})
                    
                    
                    
                    self.saveToPersistentStore()
                    complition(nil)
                    
                } catch {
                    NSLog("Error")
                    complition(error)
                    
                }
            
            }.resume()
    }
}
