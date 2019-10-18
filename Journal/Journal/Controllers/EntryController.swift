//
//  EntryController.swift
//  Journal
//
//  Created by Jessie Ann Griffin on 10/2/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case host = "HOST"
    case delete = "DELETE"
}

class EntryController {
    
    let baseURL = URL(string: "https://lambdajournalforcoredata.firebaseio.com/")
    
    private let moc = CoreDataStack.shared.mainContext
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        
        guard let baseURL = baseURL, let identifier = entry.identifier else { return }
        let uuid = UUID(uuidString: identifier) ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
//
//        let encoder = JSONEncoder()
//        do {
//            let data = try encoder.encode(entry.entryRepresentation)
//            request.httpBody = data
//        } catch {
//            print("Error encoding data: \(error)")
//            completion(error)
//            return
//        }
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion(nil)
                return
            }
            representation.identifier = identifier
            entry.identifier = identifier
            
            try CoreDataStack.shared.mainContext.save()
            
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding task (or saving to persistent store): \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error fetching entries: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        guard let identifier = entry.identifier, let baseURL = baseURL else {
            completion(nil)
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            print("Deleted entry with idetifier: \(identifier)")
            completion(error)
        }.resume()
    }
    
    
    // MARK: METHODS FOR SAVING AND LOADING DATA
    private func saveToPersistentStore() {
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving managed object context: \(error)")
        }
    }
    
    func create(title: String, bodyText: String?, timeStamp: Date, identifier: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, identifier: identifier, mood: mood)
//        saveToPersistentStore()
        put(entry: entry)
    }
    
    func update(title: String, bodyText: String?, entry: Entry, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = Date()
        entry.mood = mood
//        saveToPersistentStore()
        guard let timeStamp = entry.timeStamp, let identifier = entry.identifier else { return }
        put(entry: Entry(title: title, bodyText: bodyText, timeStamp: timeStamp, identifier: identifier, mood: mood))
    }
    
    func delete(entry: Entry) {
        moc.delete(entry)
//        saveToPersistentStore()
//        deleteEntryFromServer(entry: entry, completion: nil)
        deleteEntryFromServer(entry: entry)
    }
}
