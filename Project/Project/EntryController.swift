//
//  EntryController.swift
//  Project
//
//  Created by Ryan Murphy on 6/3/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-ios6.firebaseio.com/")!

class EntryController {
    
//    var entries: [Entry] {
//        return loadFromPersistenStore()
//    }

    func saveToPersistenStore() {
    
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        }catch {
            print("Error saving managed object context: \(error)")
        }
    
    }
    
//    func loadFromPersistenStore() -> [Entry] {
//
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let moc = CoreDataStack.shared.mainContext
//
//        do {
//            return try moc.fetch(fetchRequest)
//
//        } catch  {
//            NSLog("Error fetching entry: \(error)")
//            return []
//        }
//    }
//
    typealias CompletionHandler = (Error?) -> Void
    
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in}) {
        let uuid = entry.identifier ?? UUID()
        entry.identifier = uuid
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard let representation = entry.entryRepresentation else {throw NSError()}
            request.httpBody = try JSONEncoder().encode(representation)
            
        } catch {
            NSLog("Error encoding task: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("error Putting task to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
        
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in}) {
        let uuid = entry.identifier ?? UUID()
        entry.identifier = uuid
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        do {
            guard let representation = entry.entryRepresentation else {throw NSError()}
            request.httpBody = try JSONEncoder().encode(representation)
            
        } catch {
            NSLog("Error encoding task: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("error Putting task to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
        
    }
  
    
    func createEntry(title: String, bodyText: String, mood: Mood) {
       
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
        saveToPersistenStore()
    
}
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        put(entry: entry)
        saveToPersistenStore()
        }
    
    func delete(delete: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(delete)
        deleteEntryFromServer(entry: delete)
        saveToPersistenStore()
    }
    
    
    
    
}



