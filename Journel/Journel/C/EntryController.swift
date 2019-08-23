//
//  EntryController.swift
//  Journel
//
//  Created by Nathan Hedgeman on 8/22/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "Delete"
    case put = "PUT"
}

enum NetworkError: Error {
    case noData
    case badAuth
    case noDecode
    case failedFetch(Error)
    case failedAdd(Error)
    case badURL
    case invalidData
    case failedSignUp
    case otherError(Error)
}

class EntryController {
    
    //Properties
    let baseURL = URL(string: "https://journal-coredata-project.firebaseio.com/")!
    //    var entries: [Entry] {
    //        // this adds the stored data to the "source of all truth"
    //        //remember computed properties need to RETURN a value. So this "return" returns the value that is retuned in the loadFromPersistentStore function
    //        return loadFromPersistentStore()
    //    }
}


//MARK: - MOC functions
extension EntryController {
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving MOC: \(error)")
            moc.reset()
        }
    }
    
    //    func loadFromPersistentStore() -> [Entry] {
    //        let moc = CoreDataStack.shared.mainContext
    //        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
    //
    //        do {
    //            return try moc.fetch(fetchRequest)
    //        } catch {
    //            NSLog("Error fetching MOC: \(error)")
    //        }
    //        saveToPersistentStore()
    //        return []
    //    }
    
    //CRUD
    func create(title: String, bodyText: String?, mood: String ) {
        let entry = Entry(title: title, bodyText: bodyText)
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String?, updatedTimeStamp: Date = Date(), mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = updatedTimeStamp
        entry.mood = mood
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        deleteEntryFromServer(entry: entry)
        moc.delete(entry)
        saveToPersistentStore()
    }
}

//MARK: - Network Functions
extension EntryController {
    
    func put(entry: Entry, completion: @escaping (NetworkError?) -> Void = { _ in }) {
        let id = entry.identifier?.uuidString ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            guard var representation = entry.entryRepresentation else {completion(.otherError(NSError())); return}
            representation.identifier = UUID(uuidString: id)!
            self.saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("EntryController: Put Method : Entry: (\(entry)), not encoded")
            completion(.otherError(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("EntryController: Put Method : Error adding \(entry) to database")
                completion(.failedAdd(error))
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (NetworkError?) -> Void = { _ in }) {
        
        guard let id = entry.identifier?.uuidString else {completion(.otherError(NSError())); return}
        
        let requestURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { ( _, response, error) in
            if let error = error {
                NSLog("Error deleting \(entry) from database: \(error)")
                completion(.otherError(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                NSLog("Bad response to deleting \(entry). Response code: \(response.statusCode)")
                completion(.otherError(NSError()))
                return
            }
        }.resume()
    }
    
    func updateCoreData(entry: Entry, representation: EntryRepresentation) {
        entry.bodyText = representation.bodyText
        entry.identifier = representation.identifier
        entry.mood = representation.mood
        entry.timeStamp = representation.timeStamp
        entry.title = representation.title
    }
    
    
}
