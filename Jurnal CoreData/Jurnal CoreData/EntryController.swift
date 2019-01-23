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
    
    func create(title: String, bodyText: String, mood: String) {
        
        let newEntry = Entry(context: CoreDataStack.shared.mainContext)
        
        newEntry.bodyText = bodyText
        newEntry.title = title
        newEntry.mood = mood
        newEntry.timestamp = Date()
        newEntry.identifier = "\(UUID.self)"
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
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    
    typealias CompletionHandler = (Error?) -> Void
    
    private let baseURL = URL(string: "https://journal-b933b.firebaseio.com/")!
    
    init() {
        
        fetchEntryFromServer()
    }
    
    func fetchEntryFromServer(comletion: @escaping CompletionHandler = { _ in }){
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("No fetching tasks \(error)")
                comletion(error)
                return
            }
            guard let data = data else {
                NSLog("No data")
                comletion(NSError())
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let decodedRespose = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)   // .map({$0.value})
                    let entryRepresentation = Array(decodedRespose.values)
                    
                    self.importEntry(EntryRepresentation)
                    
                    try CoreDataStack.shared.mainContext.save()
                    comletion(nil)
                    
                } catch {
                    NSLog("Error")
                    comletion(error)
                    
                }
            }
            
            }.resume()
        
    }
    
    func save(entry: Entry, complition : @escaping CompletionHandler = {  _ in}) {
        do {
            
            guard let representation = entry.entryRepresentation else {
                throw NSError() }
            let  uuid = representation.identifier.uuidString
            let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
            var request = URLRequest(url: requestURL)
            request.httpMethod = "PUT"
            
            let body = try JSONEncoder().encode(representation)
            request.httpBody = body
            
            URLSession.shared.dataTask(with: request) { (_, _, error) in
                if let error = error {
                    NSLog("Errorsaving task \(error)")
                }
                complition(error)
                }.resume()
            
        } catch {
            
            NSLog("Error encodng task \(error)")
            complition(error)
            return
            
        }
        
    }
    
    func delete(entry: Entry, complition : @escaping CompletionHandler = {  _ in}) {
        do {
            
            guard let representation = entry.entryRepresentation else {
                throw NSError() }
            let  uuid = representation.identifier.uuidString
            let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
            var request = URLRequest(url: requestURL)
            request.httpMethod = "DELETE"
            
            
            URLSession.shared.dataTask(with: request) { (_, _, error) in
                if let error = error {
                    NSLog("Errorsaving task \(error)")
                }
                complition(error)
                }.resume()
            
        } catch {
            
            NSLog("Error encodng task \(error)")
            complition(error)
            return
            
        }
        
    }
    
    
    private func importEntry(_ entryRepresentation: [EntryRepresentation]) {
        for representation in entryRepresentation {
            if let existing = entry(for: representation.identifier) {
                update(task: existing, with: representation)
                
            } else {
                
                _ = Entry(representation: representation)
            }
            
            
        }
    }
    private func entry(for uuid: UUID) -> Entry? {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", uuid as NSUUID)
        request.predicate = predicate
        
        let moc = CoreDataStack.shared.mainContext
        let entry = try? moc.fetch(request)
        return entry?.first
    }
    private func update(entry: Entry, with representation: EntryRepresentation) {
        guard entry.identifier == representation.identifier else {
            fatalError("Updating the wrong task")
        }
        
        entry.name = representation.name
        entry.notes = representation.notes
        entry.entryPriority = representation.priority
    }
}

}
