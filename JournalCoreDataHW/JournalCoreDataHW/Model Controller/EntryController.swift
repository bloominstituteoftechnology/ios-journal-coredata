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
    
    
    /*
     The goal when fetching entries from Firebase is to go through each fetched entry and check if there is a corresponding entry in the device's persistent store
     1.No, so create a new entry object. ( this would happen if someone else created an entry on their device and you don't have it on your device yet).
     2. Yes, Are its values different from the entry fetched from Firebase? If so,  then update the entry in the persistent store with the new values from the entry from Firebase.
     
     You'll use the EntryRepresentation to do this. It will let you decode the JSON as EntryRepresentation, perform these checks and either create an actual Entry if one doesn't exist or update an existing one with its decoded values.
     */
    
    func updateTwo(entry: Entry, entryRep: EntryRepresentation){
        entry.title = entryRep.title
        entry.bodyText = entryRep.bodyText
        entry.mood = entryRep.mood
        entry.timestamp = entryRep.timestamp
    }
    
    func fetchSingleEntryFromCoreData(entryIdentifier: String) -> Entry? {
        //create a fetch request from Entry objct.
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        //give the fetchRequest an predictae - this predicate should see if the identifier attriburte in the Entry is equal to the identifier parameter of this function.
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", entryIdentifier)
        //perform the fetch request on your core data stack's maincontext
        let moc = CoreDataStack.shared.mainContext
        
        do {
            //return the first Entry from the array you get back. In theory, there should only be one entry fetched anyway.
            let entryFromCoreData = try moc.fetch(fetchRequest).first
            return entryFromCoreData
        } catch  {
            //Handle the potential error from performin the fetch request.
            print("Error making fetch request on Entry in coreData:\(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchEntriesFromServer(completion: @escaping(Error?)-> Void = {_ in }){
        let url = baseURL.appendingPathExtension("json")
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error making fetching entries from server: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("Error unwrapping data while fetching entries from server.")
                completion(NSError())
                return
            }
            var entriesOnFirebase = [EntryRepresentation]()
            //JSON -> ENTRYREPRESENTATION -> ENTRY
            let jD = JSONDecoder()
            do {
                //loop through the dictionary to return an array of just the entry representations without identifier keys
                let entryRepDictionary = try jD.decode([ String : EntryRepresentation ].self, from: data)
                let entryValues = Array(entryRepDictionary.values)
                entriesOnFirebase = entryValues
                //loop through the array of entry representations. Inside the loop, create a constant called entry. for its value, give it the result of fetchingSingleEntryFromPersistentStore. Pass in the entry representattion's identifier. This will allow us to compare the entry representation and see if thre is a corresponding entry in the persistent store already
                for entryRepOnFirebase in entriesOnFirebase {
                    //check to see if there is an entry in core data matching an entry on firebase based on its identifier.
                    if let entryOnBothCoreDataAndFirebase = self.fetchSingleEntryFromCoreData(entryIdentifier: entryRepOnFirebase.identifier) {
                        //THIS SHOULD RETURN AN ENTRY FROM CORE DATA BASED ON THE ENTRYREP IDENTIFER FROM FIREBASE SO WE NEED TO UPDATE
                        self.updateTwo(entry: entryOnBothCoreDataAndFirebase, entryRep: entryRepOnFirebase)
                    } else {
                        //entry does not exist in core data, initialize a new entry
                        let _ = Entry(entryRepresentation: entryRepOnFirebase)
                    }
                }
                self.saveToPersistentStore()
            } catch {
                print("Error decoding fetching entries from server: \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


