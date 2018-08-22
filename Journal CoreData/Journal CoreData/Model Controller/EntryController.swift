//
//  EntryController.swift
//  Journal CoreData
//
//  Created by Ngozi Ojukwu on 8/20/18.
//  Copyright © 2018 iyin. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
let moc = CoreDataStack.shared.mainContext
    
 
    
 
    func saveToPersistentStore() {
        do{
           try moc.save()
        }catch{
            NSLog("Error saving managed objects contact \(error)")
        }
        
    }
    
    func loadFromPersistenceStore() -> [Entry]{
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do{
            return try moc.fetch(fetchRequest)
        }catch{
            NSLog("error \(error) occured")
            return []
        }
    }
    
    var entries: [Entry]{
        
        return loadFromPersistenceStore()
    }
 

    
    let baseURL = URL(string: "https://journal-coredata-3d3fc.firebaseio.com/")!
    
    //Put task to firebase
    func put(entry: Entry, completion: @escaping ((Error?) -> Void) = {_ in }){
        
        guard let identifier = entry.identifier else {completion(NSError()); return}
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathComponent("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = "PUT"
        do{
            request.httpBody = try JSONEncoder().encode(entry)
        }catch {
            NSLog("Error encoding task: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error encoding task: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
        
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping ((Error?) -> Void) = { _ in }){
        guard let identifier = entry.identifier else {completion(NSError()); return}
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathComponent("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = "Delete"
        do{
            request.httpBody = try JSONEncoder().encode(entry)
        }catch {
            NSLog("Error encoding task: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error encoding task: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
 
    
    func createEntry(name:String, bodyText: String, mood: String){
        let entry = Entry(name: name, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
        put(entry: entry)
    
    }
    
    func updateEntry(entry: Entry, name: String, bodyText: String, mood:String){
        entry.name = name
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
    
       saveToPersistentStore()
        put(entry: entry)

        
    }
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.name = entryRepresentation.name
        entry.bodyText = entryRepresentation.bodyText
        entry.timestamp = entryRepresentation.timestamp
        entry.mood = entryRepresentation.mood
        
        put(entry: entry)
    }
    
      func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        deleteEntryFromServer(entry: entry)
        
        
    }
    
    func fetchSingleEntryFromPersistentStore(identifier: String) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", UUID(uuidString: identifier)! as NSUUID)
        do {
            let moc = CoreDataStack.shared.mainContext
            return try moc.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching task with uuid: \(identifier) \(error)")
            return nil
        }
    }
    
    func fetchEntriesFromServer(completion: @escaping  ((Error?) -> Void) = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data from server: \(error)")
                completion(error)
                return
            }
            completion(nil)
            
            guard let data = data else {
                NSLog("No data returned")
                completion(NSError())
                return
            }
            
            do {
                var entryRepresentations: [EntryRepresentation] = []
                let data = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                for data in data.values {
                    entryRepresentations.append(data)
                }
                
                for entryRep in entryRepresentations {
                    let entry = self.fetchSingleEntryFromPersistentStore(identifier: entryRep.identifier)
                    
                    if let entry = entry {
                        if entry == entryRep {
                            // Do nothing here
                        } else {
                            self.update(entry: entry, entryRepresentation: entryRep)
                        }
                        
                    } else {
                        let _ = Entry(entryRep: entryRep)
                        
                    }
                }
                self.saveToPersistentStore()
                completion(nil)
            } catch {
                NSLog("Error decoding data into json: \(error)")
            }
            }.resume()
        
    }
    
}

