//
//  EntryController.swift
//  JournalCoreData
//
//  Created by Angel Buenrostro on 2/11/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    let baseURL = URL(string: "https://journalcoredata-angel.firebaseio.com/")!
    
    func put(_ entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        // Create URL and URLRequest
        var url = baseURL
        url.appendPathComponent(entry.identifier!)
        url.appendPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        // Encode Entry into JSON
        let encoder = JSONEncoder()
        
        do {
            let entryJSON = try encoder.encode(entry)
            request.httpBody = entryJSON
        } catch {
            NSLog("Unable to encode entry: \(error)")
            completion(error)
        }
        
        // Perform URLSessionDataTask
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting entry to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping (Error?) -> Void = { _ in }){
        // Create URL and URLRequest
        var url = baseURL
        url.appendPathComponent(entry.identifier!)
        url.appendPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // Perform URLSessionDataTask
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    
    func saveToPersistentStore(){
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
}
    
    func createEntry(title: String, bodyText: String, mood: String){
        let newEntry = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
        put(newEntry)
    }
    
    func updateEntry(title: String, bodyText: String, mood: String, entry: Entry){
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        put(entry)
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry){
        CoreDataStack.shared.mainContext.delete(entry)
        deleteEntryFromServer(entry)
        saveToPersistentStore()
    }
}
