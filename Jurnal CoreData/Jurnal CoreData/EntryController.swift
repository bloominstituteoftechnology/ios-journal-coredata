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
    
    init() {
        fetchEntriesFromServer(context: CoreDataStack.shared.mainContext)
    }
    
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
    
    func create(title: String, bodyText: String, mood: String, identifier: String?) {
        
        let newEntry = Entry(context: CoreDataStack.shared.mainContext)
        
        newEntry.bodyText = bodyText
        newEntry.title = title
        newEntry.mood = mood
        newEntry.timestamp = Date()
        newEntry.identifier = identifier ?? UUID().uuidString
        put(entry: newEntry)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        put(entry: entry)
        saveToPersistentStore()
    }
    func delete(entry: Entry) {
        deleteEntryFromServer(entry: entry)
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    
    typealias ComplitionHandler = (Error?) -> Void
    
    private let baseURL = URL(string: "https://journal-b933b.firebaseio.com/")!
    
    
    func put(entry: Entry, comletion: @escaping ComplitionHandler = { _ in }){
        
      
        let uuid = entry.identifier
       
        let requestURL = baseURL.appendingPathComponent(uuid!).appendingPathExtension("json")
        
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
    func deleteEntryFromServer(entry: Entry, complition : @escaping ComplitionHandler = {  _ in}) {
        
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
    
    func updateEntry(toEntry: Entry, fromEntryRepresentation: EntryRepresentation) {
       
        guard let context = toEntry.managedObjectContext else { return }
        
        context.perform {
        
            guard toEntry.identifier == fromEntryRepresentation.identifier else {
                fatalError("Updating the wrong task")
            }
            
        toEntry.title = fromEntryRepresentation.title
        toEntry.bodyText = fromEntryRepresentation.bodyText
        toEntry.timestamp = fromEntryRepresentation.timestamp
        toEntry.mood = fromEntryRepresentation.mood
            
        }
    }
    
    func fetchSingleEntryFromPersistentStore(entryIdentifier: String, context: NSManagedObjectContext) -> Entry? {
         let predicate = NSPredicate(format: "identifier == %@", entryIdentifier)
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = predicate
        
       // let moc = CoreDataStack.shared.mainContext
        var entry: Entry?
        
        context.performAndWait {
           entry = (try? context.fetch(fetchRequest))?.first
        }
      
            return entry
    }
    
    func fetchEntriesFromServer(context: NSManagedObjectContext, complition: @escaping ComplitionHandler = { _ in }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
      
        
        
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
            
            DispatchQueue.main.async {
                
                do {
                    var entryRepresentations: [EntryRepresentation] = []
                    entryRepresentations = try JSONDecoder().decode([String: EntryRepresentation].self, from: data).map({$0.value})
                    print(entryRepresentations)
                    for entryRepresentation in entryRepresentations {
                        guard let identifier = entryRepresentation.identifier else { continue }
                       if let entry = self.fetchSingleEntryFromPersistentStore(entryIdentifier: identifier, context: context) {
                            self.updateEntry(toEntry: entry, fromEntryRepresentation: entryRepresentation)
                        } else {
                        _ = Entry(entryRepresentation: entryRepresentation, context: context)
                        }
                    }

                    self.saveToPersistentStore()
                    complition(nil)
                    
                } catch {
                    NSLog("Error")
                    complition(error)
                }
                }
            
            }.resume()
    }
}
