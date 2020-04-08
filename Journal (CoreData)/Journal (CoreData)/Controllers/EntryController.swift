//
//  EntryController.swift
//  Journal (CoreData)
//
//  Created by Nathan Hedgeman on 7/22/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    init() {
        fetchEntriesFromServer()
    }
    
    var baseURL = URL(string: "https://journal-coredata-project.firebaseio.com/")!
    
    //Functions
    func saveToPersistentStore() {
        
        let moc = CoreDataStack.shared.mainContext
        
        do {
            
            try moc.save()
            
        } catch {
            
            NSLog("Error saving MOC: \(error)")
            moc.reset()
            
        }
    }
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = {_ in }) {
        
        let uuid = entry.identifier ?? UUID().uuidString
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else { completion(NSError()); return }
            
            representation.identifier = uuid
            entry.identifier = uuid
            self.saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding task \(entry): \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error sending task to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    
    
    func updateEntry(entry:Entry, title: String, bodyText: String, mood: String) {
        
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        
        saveToPersistentStore()
        self.put(entry: entry)
        
    }
    
    func createEntry(title: String, bodyText: String?, mood: String) {
        
        let entry = Entry(title: title, bodyText: bodyText, mood: mood )
        
        saveToPersistentStore()
        self.put(entry: entry)
    }
    
    func deleteEntry(entry: Entry) {
        
        let moc = CoreDataStack.shared.mainContext
        
        self.deleteEntryFromServer(entry: entry)
        
        moc.delete(entry)
        
        saveToPersistentStore()
        
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = {_ in}) {
        
        guard let uuid = entry.identifier else {
            completion(NSError())
            return }
        
       
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                NSLog("Error Deleting Entry From Server \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                NSLog("Bad response fetching entries, response code: \(response.statusCode)")
                completion(error)
                return
            }
            
            }.resume()
    }
    
    //Functions for syncing the firebase data with Coredata
    func update(entry: Entry, entryRep: EntryRepresentation) {
        
        entry.bodyText = entryRep.bodyText
        entry.identifier = entryRep.identifier
        entry.mood = entryRep.mood
        entry.timestamp = entryRep.timestamp
        entry.title = entryRep.title
    }
    
    func fetchEntryFromStore(uuid: String) -> Entry? {
        
        let fetchRequest:NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid)
        
        do{
            
            let moc = CoreDataStack.shared.mainContext
            return try moc.fetch(fetchRequest).first
            
        } catch {
            
            NSLog("Error fetching UUID and Entry: \(uuid) and \(error)")
            return nil
        }
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        
        let getURL = baseURL.appendingPathExtension("json")
    
        
        URLSession.shared.dataTask(with: getURL) { (data, response, error) in
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                NSLog("Bad response fetching entries, response code: \(response.statusCode)")
                completion(error)
                return
            }
            guard let data = data else { NSLog("No data returned by the data task"); completion(error); return }
            
            DispatchQueue.main.async {
                do {
                    let entryReps = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                    for entryRep in entryReps {
                        guard let identifier = entryRep.identifier else {return}
                        if let entry = self.fetchEntryFromStore(uuid: identifier) {
                            self.update(entry: entry, entryRep: entryRep)
                        } else {
                            let _ = Entry(entryRep: entryRep)
                        }
                    }
                    
                    self.saveToPersistentStore()
                    completion(nil)
                } catch {
                    NSLog("Error decoding task representations: \(error)")
                    completion(error)
                    return
                }
            }
            }.resume()
    }
}
