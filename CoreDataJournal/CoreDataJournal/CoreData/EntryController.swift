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
    
    func deleteEntry(entry: Entry){
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        deleteEntryFromServer(entry: entry)
        saveToPersistentStore()
    }
    
}
