//
//  EntryController.swift
//  Journal
//
//  Created by Chad Rutherford on 12/16/19.
//  Copyright © 2019 Chad Rutherford. All rights reserved.
//

import CoreData
import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class EntryController {
    
    typealias CompletionHandler = (Error?) -> ()
    private let baseURL = URL(string: "https://journal-f8c88.firebaseio.com/")
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let identifier = entry.identifier ?? UUID().uuidString
        guard let requestURL = baseURL?.appendingPathComponent(identifier).appendingPathExtension("json") else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        let encoder = JSONEncoder()
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            
            representation.identifier = identifier
            entry.identifier = identifier
            try saveToPersistentStore()
            request.httpBody = try encoder.encode(representation)
        } catch let encodeError {
            print("Error encoding entry: \(encodeError.localizedDescription)")
            completion(encodeError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error PUTting entry to server: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(error)
                    return
                }
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    private func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch let saveError {
            print("Error saving entries: \(saveError.localizedDescription)")
        }
    }
    
    func createEntry(title: String, bodyText: String, mood: String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        deleteEntryFromServer(entry)
        moc.delete(entry)
        do {
            try moc.save()
        } catch let deleteError {
            moc.reset()
            print("Error deleting entries: \(deleteError.localizedDescription)")
        }
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier, let requestURL = baseURL?.appendingPathComponent(identifier).appendingPathExtension("json") else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error deleting entry from server: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(error)
                    return
                }
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
}
