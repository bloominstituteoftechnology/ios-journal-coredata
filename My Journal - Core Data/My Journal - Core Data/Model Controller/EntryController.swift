//
//  EntryController.swift
//  My Journal - Core Data
//
//  Created by Nick Nguyen on 2/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import CoreData

class EntryController 
{
    
    let baseURL = URL(string: "https://my-journal-core-data.firebaseio.com/")!
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        
    }
    
   // MARK: - CRUD methods
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
   
    func create(title:String,bodyText:String,identifier: UUID, mood:String, date: Date) {
        let _ = Entry(title: title,
                      bodyText: bodyText,
                      timestamp: date,
                      identifier: UUID() ,
                      context: CoreDataStack.shared.mainContext,
                      mood: mood)
                    saveToPersistentStore()
    }
    
    
    func update(with newTitle : String, bodyText: String,mood: String,identifier: UUID, entry: Entry) {
        DispatchQueue.main.async {
            entry.title = newTitle
            entry.bodyText = bodyText
            entry.mood = mood
            entry.identifier = UUID()
            entry.timestamp = Date()
        }
      
        saveToPersistentStore()
    
    }
   
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        saveToPersistentStore()
    }
    
    func put(entry: Entry,completion: @escaping CompletionHandler = {_ in } ) {
        var newURL = baseURL.appendingPathExtension("json")
        newURL.appendPathComponent(entry.identifier!.uuidString)
        var requestURL = URLRequest(url:newURL )
        requestURL.httpMethod = "PUT"
        
        let jsonEncoder = JSONEncoder()
        do {
              requestURL.httpBody = try jsonEncoder.encode(entry.entryRepresentation)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
  
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if let error = error {
                NSLog("Error sending data to sever: \(error)")
                completion(error)
                return
            }
            
            
            guard let data = data else {
                NSLog("No data ")
                completion(NSError())
                return
            }
            guard let response = response else { return }
            
            do {
              // TODO
            } catch let error as NSError {
                NSLog("Error sending data to sever:\(error)")
                completion(error)
            }
            
            
        }.resume()
        
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = {_ in  }) {
        var newURL = baseURL.appendingPathExtension("json")
              newURL.appendPathComponent(entry.identifier!.uuidString)
              var requestURL = URLRequest(url:newURL )
              requestURL.httpMethod = "DELETE"
        
        
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            guard let data = data else {
                completion(NSError())
                return
            }
 //TODO
        }.resume()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
