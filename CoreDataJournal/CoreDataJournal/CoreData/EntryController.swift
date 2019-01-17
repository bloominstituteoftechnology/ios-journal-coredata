//
//  EntryController.swift
//  CoreDataJournal
//
//  Created by Benjamin Hakes on 1/14/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EntryController {
    
    typealias CompletionHandler = (Error?) -> Void
    
    private let baseURL = URL(string: "https://first-project-263b0.firebaseio.com/")!
    
    init() {
        // TODO: Implement init
        fetchEntriesFromServer()
    }
    
    func fetchEntriesFromServer(completionHandler: @escaping CompletionHandler = {_ in }){
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completionHandler(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by data entry")
                completionHandler(NSError())
                return
            }
            
            let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
            
            do {
                let entryRepresentationsDict = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                let entryRepresentations = Array(entryRepresentationsDict.values)
                
                    for entryRep in entryRepresentations {
                        let uuid = entryRep.identifier
                        
                        // TODO: Make sure that this is the correct context/queue
                        if let entry = self.entry(forUUID: uuid, in: backgroundContext){
                            // we already have a local task for this
                            self.update(entry: entry, with: entryRep)
                            
                        } else {
                            // need to create a new task in Core Data
                            backgroundContext.perform {
                                let _ = Entry(entryRepresentation: entryRep, context: backgroundContext)
                            }
                        }
                    
                    }
                
                try CoreDataStack.shared.save(context: backgroundContext)
                
            } catch {
                NSLog("Error decoding tasks: \(error)")
                completionHandler(error)
                return
            }
            
            completionHandler(nil)
        }.resume()
    }
    
    func put(entry: Entry, completionHandler: @escaping CompletionHandler = { _ in }) {
        
        // turn the entry into an entry representation
        
        // send the entry representation to the server
        
        guard let uuid = entry.identifier else {fatalError("could not get UUID")}
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            
            request.httpBody = try JSONEncoder().encode(entry)
            
            URLSession.shared.dataTask(with: request){ (_, _, error) in
                if let error = error {
                    print ("Error putting task to server: \(error)")
                }
                completionHandler(error)
            }.resume()
            
            
        } catch {
            print("errors putting entry to server \(error)")
            completionHandler(error)
        }
    
    }
    
    func deleteEntryFromServer(entry: Entry, completionHandler: @escaping CompletionHandler = {_ in }) {
        //turn the task into a task Representation
        
        // ssend the task representation to the server
        
        do {
            guard let representation = entry.entryRepresentation else { throw NSError() }
            
            let uuid = representation.identifier.uuidString
            
            let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
            var request = URLRequest(url: requestURL)
            request.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: request) { (_, _, error) in
                if let error = error {
                    print("error deleting task: \(error)")
                }
                completionHandler(error)
                }.resume()
            
        } catch {
            print("error deleting entry")
            completionHandler(error)
            
        }
    }
    
    func saveToPersistentStore(){
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        
    }
    
    func createEntry(title: String, mood: EntryMood, bodyText: String?){
        
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, mood: EntryMood, bodyText: String?){
       
        entry.bodyText = bodyText
        entry.mood = mood.rawValue
        entry.title = title
        
        put(entry: entry)
        saveToPersistentStore()
    }
    
    /**
     'deleteEntry' is a function with the purpose of removing an entry from .
     
     - Parameter entry: The entry that we would like to delete.
     
     - Returns: Void.
     */
    func deleteEntry(entry: Entry){
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        deleteEntryFromServer(entry: entry)
        saveToPersistentStore()
    }
    
    /**
     'update' is a private function with the purpose translating an EntityRepresentation object to an Entity object.
     
     - Parameter entry: The entry that we would like to update.
     - Parameter (with) reprepresentation: a representation we would like to use for the basis of updating the Entry object.
     
     - Returns: Void.
     */
    private func update(entry: Entry, with representation: EntryRepresentation){
        
        guard let moc = entry.managedObjectContext else { return }
    
        moc.performAndWait {
            entry.title = representation.title
            entry.bodyText = representation.bodyText
            entry.mood = representation.mood.rawValue
            entry.identifier = representation.identifier
            entry.timestamp = representation.timestamp
        }
        
    }
    
    /**
     'entry' is a private function with the purpose of looking up an entry by UUID in the persistent store and returning the entry related to that UUID if it exists.
     - Parameter uuid: The UUID that is being looked up.
     - Parameter managedObjectContext: a given NSManagedObjectContext.
     
     - Returns: the entry for the given UUID and the given NSManagedObjectContext.
    */
    private func entry(forUUID uuid: UUID, in managedObjectContext: NSManagedObjectContext) -> Entry? {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid as NSUUID)
        
        var entry: Entry?
        
        managedObjectContext.performAndWait {
            entry = (try? managedObjectContext.fetch(fetchRequest))?.first
        }
        
        return entry
    }
    
}
