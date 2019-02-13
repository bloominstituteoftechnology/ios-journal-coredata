//
//  EntryController.swift
//  Journal
//
//  Created by Moses Robinson on 2/11/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case put = "PUT"
    case delete = "DELETE"
}

class EntryController {
    
    func put(_ entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        
        let identifier = entry.identifier ?? UUID().uuidString
        
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.put.rawValue
        
        let jsonEncoder = JSONEncoder()
        
        do {
            
            let entryData = try jsonEncoder.encode(entry)
            urlRequest.httpBody = entryData
        } catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                NSLog("Error putting entry to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }
        dataTask.resume()
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        let identifier = entry.identifier ?? UUID().uuidString
        
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.delete.rawValue
        
        let jsonEncoder = JSONEncoder()
        
        do {
            
            let entryData = try jsonEncoder.encode(entry)
            urlRequest.httpBody = entryData
        } catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                NSLog("Error putting entry to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }
        dataTask.resume()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func create(title: String, bodyText: String, mood: EntryMood) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        
        put(entry)
        
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, timestamp: Date = Date(), mood: String) {
         
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp
        entry.mood = mood
        
        put(entry)
        
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        deleteEntryFromServer(entry)
        
        saveToPersistentStore()
    }
    
    // MARK: - Properties
    
    let baseURL = URL(string: "https://journal-core-data-sync.firebaseio.com/")!
    
}
