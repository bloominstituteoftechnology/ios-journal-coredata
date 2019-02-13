//
//  EntryController.swift
//  JournalCoreData
//
//  Created by Nelson Gonzalez on 2/11/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
//   var entries: [Entry] {
//      return  loadFromPersistentStore()
//    }
    
   private let baseURL = URL(string: "https://nelson-ios-journal.firebaseio.com/")!
    
    
    func saveToPersistentStore(){
        //Save changes to disk
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()//Save the task to the persistent store
        } catch {
            print("Error saving MOC (managed object context): \(error)")
        }
    }
    

    
    func create(title: String, body: String, mood: Mood) {
        
        let newEntry = Entry(title: title, bodyText: body, mood: mood)
      
//        let newEntry = Entry(context: CoreDataStack.shared.mainContext)
//        newEntry.title = title
//        newEntry.bodyText = body
//        newEntry.timestamp = Date()
//        newEntry.identifier = UUID().uuidString
//        newEntry.mood = mood.rawValue
        
        
        saveToPersistentStore()
        
        self.put(entry: newEntry)
    }
    
    func update(title: String, body: String, entry: Entry, mood: String){

        entry.title = title
        entry.bodyText = body
        entry.timestamp = Date()
        entry.mood = mood
    
       saveToPersistentStore()
        //entry from above
        self.put(entry: entry)
    }
    
    func delete(entry: Entry){
        let moc = CoreDataStack.shared.mainContext
        
            moc.delete(entry)//Remore from moc but not persistent store.
            saveToPersistentStore()
        self.delete(entry: entry)

    }
    
    // Give this completion closure a default value of an empty closure. (e.g. { _ in } ). This will allow you to use the completion closure if you want to do something when completion is called or just not worry about doing anything after knowing the data task has completed.
    func put(entry: Entry, completion: @escaping(Error?)-> Void = { _ in }) {
        guard let identifier = entry.identifier else {return}
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        
        do {
           let jsonData = try encoder.encode(entry)
            urlRequest.httpBody = jsonData
        } catch {
            print("error encoding entry: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                print("Error with request: \(error)")
                completion(error)
                return
            }
        }.resume()
        
    }
    
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping(Error?) -> Void = { _ in }) {
        guard let identifier = entry.identifier else {return}
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                print("Error deleting entry: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
   
}
