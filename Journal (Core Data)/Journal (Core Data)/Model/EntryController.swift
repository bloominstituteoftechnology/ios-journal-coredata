//
//  EntryController.swift
//  Journal (Core Data)
//
//  Created by David Wright on 2/12/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-693f9.firebaseio.com/")!

class EntryController {
        
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - CRUD Methods
    
    private func putEntryToServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuidString = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        do {
        guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = uuidString
            entry.identifier = uuidString
            saveToPersistentStore()
            request.httpBody = try jsonEncoder.encode(representation)
        } catch {
            print("Error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                print("Error PUTting entry to server: \(error!)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    private func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuidString = entry.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            guard error == nil else {
                print("Error deleting entry: \(error!)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    // MARK: - CRUD Methods

    // Create Entry
    func createEntry(withTitle title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        putEntryToServer(entry)
    }
    
    // Update Entry
    func updateEntry(_ entry: Entry, updatedTitle: String, updatedBodyText: String, updatedMood: String) {
        let updatedTimestamp = Date()
        entry.title = updatedTitle
        entry.bodyText = updatedBodyText
        entry.timestamp = updatedTimestamp
        entry.mood = updatedMood
        putEntryToServer(entry)
    }
    
    // Delete Entry
    func deleteEntry(_ entry: Entry) {
        deleteEntryFromServer(entry) { (error) in
            guard error == nil else {
                print("Error deleting entry from server: \(error!)")
                return
            }
            
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            
            self.saveToPersistentStore()
        }
    }
    
    // MARK: - Persistence

    private func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error saving to persistent store: \(error)")
        }
    }
}
