//
//  JournalController.swift
//  Journal
//
//  Created by Farhan on 9/17/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation
import CoreData

class JournalController {
    
//    var journal: [Journal]{
//
//        let request: NSFetchRequest<Journal> = Journal.fetchRequest()
//
//        let moc = CoreDataStack.shared.mainContext
//
//        do {
//            return try moc.fetch(request)
//        } catch{
//            NSLog("Tasks FETCH failed: \(error)")
//            return []
//        }
//
//    }
    typealias CompletionHandler = (Error?) -> Void
    let baseURL = URL(string: "https://farhanf-journal.firebaseio.com/")
    
    
    func createJournalEntry(with title: String, and notes: String?, mood: String){
        
        let entry = Journal(title: title, notes: notes, mood: mood)
        put(entry: entry)
        
        saveToPersistentStorage()
        
    }
    
    func updateJournalEntry(entry: Journal, with title:String, and notes: String?, mood: String){
        
        entry.title = title
        entry.notes = notes
        entry.mood = mood
        
        put(entry: entry)
        
        saveToPersistentStorage()
        
    }
    
    func deleteJournalEntry(entry: Journal){
        
        let moc = CoreDataStack.shared.mainContext
        deletefromServer(entry: entry)
        moc.delete(entry)
        saveToPersistentStorage()
        
    }
    
    func saveToPersistentStorage(){
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        }catch{
            NSLog("Error saving Managed Object Context: \(error)")
        }
    }
    
    func deletefromServer(entry: Journal, completion: @escaping CompletionHandler = {_ in}){
        
        let requestURL = baseURL?.appendingPathComponent(entry.identifier ?? UUID().uuidString).appendingPathExtension("json")
//        print(requestURL)
        var request = URLRequest(url: requestURL!)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error DELETEing entry: \(error)")
                completion(error)
                return
            }
            print(response ?? "delete successful")
            completion(nil)
            
            }.resume()
        
    }
    
    func put(entry: Journal, completion: @escaping CompletionHandler = {_ in}){
        
        let requestURL = baseURL?.appendingPathComponent(entry.identifier ?? UUID().uuidString).appendingPathExtension("json")
//        print(requestURL)
        var request = URLRequest(url: requestURL!)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do { request.httpBody = try JSONEncoder().encode(entry)}
        catch{
            NSLog("Error Encoding Data: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error PUTing entry: \(error)")
                completion(error)
                return
            }
            print(response ?? "PUT successful")
            completion(nil)
            
            }.resume()
        
    }
    
    
}
