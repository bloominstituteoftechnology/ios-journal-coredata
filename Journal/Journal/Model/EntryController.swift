//
//  EntryController.swift
//  Journal
//
//  Created by denis cedeno on 12/4/19.
//  Copyright © 2019 DenCedeno Co. All rights reserved.
//

import Foundation
import CoreData



class EntryController {
    
    //    var entries: [Entry] {
    //        loadFromPersistentStore()
    //    }
    typealias CompletionHandler = (Error?) -> Void
    private let baseURL = URL(string: "https://journal-c0a50.firebaseio.com/")!
    
    private func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    func put(entry: Entry, completion: @escaping () -> Void = { }){
        let uuid = entry.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        do {
            guard var representation = entry.entryRepresentation else {
                completion()
                return
            }
            representation.identifier = uuid.uuidString
            entry.identifier = uuid
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding task \(entry): \(error)")
            completion()
            return
        }
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print("Error PUTing entry to server: \(error!)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    
    
    func create(title: String, bodyText: String, mood: String, timeStamp: Date) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood, timeStamp: timeStamp)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timeStamp = Date()
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func delete(for entry: Entry) {
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in}) {
        guard let uuid = entry.identifier else {
            completion(NSError())
            return
        }
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            completion(error)
        }.resume()
    }
    
    
}
