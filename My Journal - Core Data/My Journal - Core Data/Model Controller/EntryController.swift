//
//  EntryController.swift
//  My Journal - Core Data
//
//  Created by Nick Nguyen on 2/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import CoreData

class EntryController 
{
    
    let baseURL = URL(string: "https://my-journal-core-data.firebaseio.com/")!
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchEntriesFromSever()
    }
    
   // MARK: - CRUD methods
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
   
    func create(title:String,bodyText:String,identifier: UUID, mood:String, date: Date) {
        let _ = Entry(title: title,
                      bodyText: bodyText,
                      timestamp: date,
                      identifier: UUID() ,
                      context: CoreDataStack.shared.mainContext,
                      mood: mood)
                    saveToPersistentStore()
    }
    
    
    func updateEntry(with newTitle : String, bodyText: String,mood: String,identifier: UUID, entry: Entry) {
        DispatchQueue.main.async {
            entry.title = newTitle
            entry.bodyText = bodyText
            entry.mood = mood
            entry.identifier = UUID()
            entry.timestamp = Date()
        }
      
        saveToPersistentStore()
    
    }
   
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    // MARK: - PUT
    
    func put(entry: Entry,completion: @escaping CompletionHandler = {_ in } ) {
        var newURL = baseURL.appendingPathExtension("json")
        newURL.appendPathComponent(entry.identifier!.uuidString)
        var requestURL = URLRequest(url:newURL )
        requestURL.httpMethod = "PUT"
        
        let jsonEncoder = JSONEncoder()
        do {
              requestURL.httpBody = try jsonEncoder.encode(entry.entryRepresentation)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
  
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if let error = error {
                NSLog("Error sending data to sever: \(error)")
                completion(error)
                return
            }
            
            
            guard let _ = data else {
                NSLog("No data ")
                completion(NSError())
                return
            }
            guard let _ = response else { return }
            
            do {
              // TODO
            } catch let error as NSError {
                NSLog("Error sending data to sever:\(error)")
                completion(error)
            }
            
            
        }.resume()
        
    }
  //MARK: - DELETE
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = {_ in  }) {
        var newURL = baseURL.appendingPathExtension("json")
              newURL.appendPathComponent(entry.identifier!.uuidString)
              var requestURL = URLRequest(url:newURL )
              requestURL.httpMethod = "DELETE"
        
        
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            guard let _ = data else {
                completion(NSError())
                return
            }
              //TODO
        }.resume()
        
    
    }
    //MARK: - GET
    
    func fetchEntriesFromSever(completion: @escaping CompletionHandler = { _ in }) {
           let requestURL = baseURL.appendingPathExtension("json")
           
           URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
               if let error = error {
                   NSLog("Error fetching entries from Firebase: \(error)")
                   completion(error)
                   return
               }
               
               guard let data = data else {
                   NSLog("No data returned from Firebase")
                   completion(NSError())
                   return
               }
               
               do {
                   let entriesRepresentation = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                   try self.updateEntries(with: entriesRepresentation)
                   completion(nil)
               } catch {
                   NSLog("Error decoding entries representations from Firebase: \(error)")
                   completion(error)
               }
           }.resume()
       }
    
    // MARK: - Update Entries
    
    
   private func updateEntries(with representations: [EntryRepresentation]) throws {
    
        let entriesWithID = representations.filter { $0.identifier != nil }
    
        let identifiersToFetch = entriesWithID.compactMap { UUID(uuidString: $0.identifier!) }
    
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
    
        var entriesToCreate = representationsByID
        
        // fetch all? tasks from Core Data
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        do {
            let existingEntries = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            
            // Match the managed tasks with the Firebase tasks
            for entry in existingEntries{
                
                guard let id = entry.identifier,
                    let representation = representationsByID[id] else { continue }
                
                self.update(entry: entry, with: representation)
                entriesToCreate.removeValue(forKey: id)
                saveToPersistentStore()
            }
            
            // For nonmatched (new tasks from Firebase), create managed objects
            for representation in entriesToCreate.values {
             Entry(entryRepresentation: representation)
                saveToPersistentStore()
            }
        } catch {
            NSLog("Error fetching tasks for UUIDs: \(error)")
        }
        
        // Save all this in CD
     saveToPersistentStore()
    }
    
    private func update(entry: Entry, with representation: EntryRepresentation) {
    
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.timestamp = representation.timestamp
        entry.mood = representation.mood
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
