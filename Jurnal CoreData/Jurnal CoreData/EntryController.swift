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
//
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
    
    
    
//    private func importEntry(_ entryRepresentation: [EntryRepresentation]) {
//        for representation in entryRepresentation {
//            if let existing = entry(for: representation.identifier) {
//                update(task: existing, with: representation)
//
//            } else {
//
//                _ = Entry(representation: representation)
//            }
//
//
//        }
//    }
//    private func entry(for uuid: UUID) -> Entry? {
//        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let predicate = NSPredicate(format: "identifier == %@", uuid as NSUUID)
//        request.predicate = predicate
//
//        let moc = CoreDataStack.shared.mainContext
//        let entry = try? moc.fetch(request)
//        return entry?.first
//    }
//    private func update(entry: Entry, with representation: EntryRepresentation) {
//        guard entry.identifier == representation.identifier else {
//            fatalError("Updating the wrong task")
//        }
//
//        entry.name = representation.name
//        entry.notes = representation.notes
//        entry.entryPriority = representation.priority
//    }


}
