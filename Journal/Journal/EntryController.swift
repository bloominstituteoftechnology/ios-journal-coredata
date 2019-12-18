//
//  EntryController.swift
//  Journal
//
//  Created by Lambda_School_Loaner_218 on 12/16/19.
//  Copyright © 2019 Lambda_School_Loaner_218. All rights reserved.
//

import CoreData
import Foundation

enum HTTPMethood: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class EntryController {
    
    typealias CompletionHandler = (Error?) -> Void
    private let baseURL = URL(string: "https://journal-dca4e.firebaseio.com/")
    
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let identifire = entry.identifier ?? UUID().uuidString
        guard let requestURL = baseURL?.appendingPathComponent(identifire).appendingPathExtension("json") else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethood.put.rawValue
        
        let encoder = JSONEncoder()
        do {
            guard var representation = entry.entryRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = identifire
            entry.identifier = identifire
            try saveToPersistentStore()
            request.httpBody = try encoder.encode(representation)
        } catch let encodeError {
            print("Error encoding entry: \(encodeError.localizedDescription)")
            completion(encodeError)
            return
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error putting entry to server: \(error.localizedDescription)")
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
    
    var entries: [Entry] {
       return loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch let saveError {
            print("Error saving entries: \(saveError.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore() ->[Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
        } catch let loadError {
            print("Error loading entries: \(loadError.localizedDescription)")
            return []
        }
    }
    
    func createEntry(title: String, bodyText: String, mood:String) {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodytext = bodyText
        entry.timestamp = Date()
        entry.mood = mood
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
            print("Error deleting entry \(deleteError.localizedDescription)")
        }
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = {_ in}) {
        guard let identifier = entry.identifier, let requestURL = baseURL?.appendingPathComponent(identifier).appendingPathExtension("json") else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethood.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                print("Error deleteing entry from server: \(error.localizedDescription)")
                DispatchQueue.main.async{
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
