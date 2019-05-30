//
//  EntryController.swift
//  JournalCoreDataHW
//
//  Created by Michael Flowers on 5/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

class EntryController {

    func createEntry(title: String, bodyText: String, mood: EntryMood){
        let entryToPut = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entryToPut)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, newTitle: String, newBodyText: String, newTimestamp: Date, newMood: EntryMood){
        entry.title = newTitle
        entry.bodyText = newBodyText
        entry.timestamp = newTimestamp
        entry.mood = newMood.rawValue
        put(entry: entry)
        saveToPersistentStore()
    }
    
    func delete(entry: Entry){
        CoreDataStack.shared.mainContext.delete(entry)
        deleteFromServer(entry: entry)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch  {
            print("Error in the saving to persistent store function: \(error.localizedDescription)")
        }
    }

    //MARK: - API CALLS
    let baseURL = URL(string: "https://journalcd-f7246.firebaseio.com/")!
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = {_  in}){
        //this method should append the identifier and add the json to the extension bc of firebase
        guard let identifier = entry.identifier else {
            print("Error unwrapping identifier")
            completion(NSError())
            return }
        
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var requestURL = URLRequest(url: url)
        requestURL.httpMethod = "PUT"
        
        //put the entry's representation into the body of the http
        //Entry -> EntryRepresentation -> JSON - encode
        do {
            guard let entryRep = entry.entryRepresentation else {
                print("Error turning entry into entry representationfor the encoder")
                completion(NSError())
                return
            }
            let jsonData = try JSONEncoder().encode(entryRep)
            requestURL.httpBody = jsonData
        } catch  {
            print("Error putting the entry into the httpbody: \(error.localizedDescription)")
            completion(error)
            return
        }
        
        //we can make our urlsession call
        URLSession.shared.dataTask(with: requestURL) { (_, _, error) in
            if let error = error {
                print("Error PUTing the entry on firebase: \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteFromServer(entry: Entry, completion: @escaping(Error?) -> Void = {_ in }){
        //construct url, because -- we will have to use the identifier from the entry we pass in as an argument
        guard let identifier = entry.identifier else {
            print("Error unwrapping identifier in the delete from server function.")
            completion(NSError())
            return }
        
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var requestURL = URLRequest(url: url)
        requestURL.httpMethod = "DELETE"
        
        //we do not have to put anything in the httpBody
        URLSession.shared.dataTask(with: requestURL) { (_, _, error) in
            if let error = error {
                print("Error deleting from the server: \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
        
    }
}


