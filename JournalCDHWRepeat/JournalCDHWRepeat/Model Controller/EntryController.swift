//
//  EntryController.swift
//  JournalCDHWRepeat
//
//  Created by Michael Flowers on 6/4/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    init(){
        fetchEntriesFromServer()
    }
    
    func createEntry(title: String, bodyText: String, mood: EntryMood){
        let newEntry = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry:newEntry )
        saveToPersistentStore()
    }
    
    func update(entry: Entry, newTitle: String, newBody: String, newTimestamp: Date = Date(), newMood: EntryMood){
        entry.title = newTitle
        entry.bodyText = newBody
        entry.timestamp = newTimestamp
        entry.mood = newMood.rawValue
        put(entry: entry) // does this go before the save func?
        saveToPersistentStore()
    }
    
    func delete(entry: Entry){
        CoreDataStack.shared.mainContext.delete(entry)
        deleteEntryFromServer(entry: entry)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore(){
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch  {
            print("Error saving to persistent stores:\(error.localizedDescription)")
        }
    }
    
    //MARK: FIREBASE Functionality - DAY 3...
    let baseUrl = URL(string: "https://journalcd-f7246.firebaseio.com/")!
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = {_ in }){
        guard let identifier = entry.identifier else { print("error with identifier"); completion(NSError()); return }
        let url = baseUrl.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        guard let entryRep = entry.entryRep else { print("Error turning entry into entryRep"); completion(NSError()); return }
        
        let jE = JSONEncoder()
        do {
           let jsonData =  try jE.encode(entryRep)
            request.httpBody = jsonData
        } catch  {
            print("Error encoding entryRepresentation:\(error.localizedDescription)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse {
                print("This is the status code: \(response.statusCode)")
            }
            
            if let error = error {
                print("Error putting entryRep to theserver: \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping (Error?) -> Void = {_ in }){
        guard let identifier = entry.identifier else { print("error with identifier"); completion(NSError()); return }
        let url = baseUrl.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse {
                print("This is the deletion response :\(response.statusCode)")
            }
            
            if let error = error {
                print("Error deleting the entry from server: \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    //MARK: CHECKING CORE DATA AND SERVER
    func updateCheck(entry: Entry, entryRep: EntryRepresentation){
        //this should set each of the Entry's values to the ER/s corresponding values. Dont call save to persistent store inthis function
        entry.title = entryRep.title
        entry.bodyText = entryRep.bodyText
        entry.mood = entryRep.mood
        entry.timestamp = entryRep.timestamp
        //do i need the identifier?
//        entry.identifier = entryRep.identifier
    }
    
    func fetchSingleEntryFromCoreData(identifier: String) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        let moc = CoreDataStack.shared.mainContext
        
        var entry: Entry? = nil
        do {
            entry = try moc.fetch(fetchRequest).first
        } catch  {
            print("Error fetching entry from core data: \(error.localizedDescription)")
        }
        return entry
    }
    
    func fetchEntriesFromServer(completion: @escaping (Error?) -> Void = {_ in }){
        let url = baseUrl.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("This is the status code for fetching all entries: \(response.statusCode)")
            }
            
            if let error = error {
                print("Error fetching all entries: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            guard let data = data else { print("Error unwrapping data in the fetch all"); completion(NSError()); return }
            
            var entryRepsFromServer: [EntryRepresentation]
            
            let jD = JSONDecoder()
            do {
                let entryRepDictionary = try jD.decode([ String : EntryRepresentation ].self, from: data)
                let entryArray = Array(entryRepDictionary.values)
                entryRepsFromServer = entryArray
                
                //should this be outside of the do-try-catch block?
                for entryRep in entryRepsFromServer {
                    if let entry = self.fetchSingleEntryFromCoreData(identifier: entryRep.identifier){
                        //there is an entry in core data that matches an entry on the server, so we just need to update it
                        self.updateCheck(entry: entry, entryRep: entryRep)
                    } else {
                        //there is not an entry in core data but there is on the server so we have to create an entry and save it to core data
                        let entryToSaveToCoreData = Entry(entryRepresentation: entryRep)
                        //if something happens then check the context in the initializer
                        //why don't we call create entry function right here?
                    }
                }
                try CoreDataStack.shared.mainContext.save()
            } catch {
                print("checking to see if entry is in core data and the server: \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
