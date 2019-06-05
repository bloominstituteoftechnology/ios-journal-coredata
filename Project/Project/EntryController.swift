//
//  EntryController.swift
//  Project
//
//  Created by Ryan Murphy on 6/3/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://journal-48ed0.firebaseio.com/")!

class EntryController {
    
//    var entries: [Entry] {
//        return loadFromPersistenStore()
//    }

    init() {
        fetchEntriesFromServer()
    }
    
    
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
            guard let representation = entry.entryRepresentation else { throw NSError() }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding entry: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTting entry to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
        
    }
    
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        guard let identifier = entry.identifier else {
            NSLog("Entry identifier is nil")
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
//    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in}) {
////        guard let identifier = entry.identifier else {
////            NSLog("Entry identifier is nil")
////            completion(NSError())
////            return
////        }
//        
//        let requestURL = baseURL.appendingPathExtension("json")
//        var request = URLRequest(url: requestURL)
//        request.httpMethod = "DELETE"
//
//        URLSession.shared.dataTask(with: request) { (_, _, error) in
//            if let error = error {
//                print("error deleting entry from server: \(error)")
//                completion(error)
//                return
//            }
//            completion(nil)
//            }.resume()
//
//    }
  
    
    func createEntry(title: String, bodyText: String, mood: Mood) {
       
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
        saveToPersistenStore()
    
}
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.mood = entryRepresentation.mood
        entry.identifier = entryRepresentation.identifier
        entry.timestamp = entryRepresentation.timestamp
    }
    
    private func fetchSingleEntryFromPersistentStore(forUUID uuid: UUID) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid as NSUUID) //identifier == uuid
        let moc = CoreDataStack.shared.mainContext
        return (try? moc.fetch(fetchRequest))?.first
        
        
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, mood: Mood) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        put(entry: entry)
        saveToPersistenStore()
        }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        print(entry)
        deleteEntryFromServer(entry: entry)
        saveToPersistenStore()
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = {_ in}) {
        let requestURL = baseURL.appendingPathExtension("json")
        // this add .json at the end of .com/
        
        URLSession.shared.dataTask(with: requestURL) {(data, _, error) in
            if let error = error {
                NSLog("Error fetching entries: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by data task")
                completion(NSError())
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let entryReqresentationDict = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                    let entryRepresentations = Array(entryReqresentationDict.values)
                    
                    for entryRep in entryRepresentations {
                        let uuid = entryRep.identifier
                        
                        if let entry = self.fetchSingleEntryFromPersistentStore(forUUID: uuid){
                            
                            self.update(entry: entry, entryRepresentation: entryRep)
                        }else {
                            let _ = Entry(entryRepresentation: entryRep)
                        }
                        
                        
                    }
                    // save changes to disk
                    let moc = CoreDataStack.shared.mainContext
                    try moc.save()
                }catch{
                    NSLog("Error decoding entries: \(error)")
                    completion(error)
                    return
                }
            }
            completion(nil)
            
            
            
            }.resume()
        
        
    }


}


