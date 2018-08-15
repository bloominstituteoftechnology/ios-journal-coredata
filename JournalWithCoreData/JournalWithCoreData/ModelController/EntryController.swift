//
//  EntryController.swift
//  JournalWithCoreData
//
//  Created by Carolyn Lea on 8/13/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://day3-journal.firebaseio.com/")!

class EntryController
{
    var entry: Entry?
    typealias CompletionHandler = (Error?) -> Void
    
    func saveToPersistentStore()
    {
        do
        {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
            print("save")
        }
        catch
        {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func createEntry(title: String, bodyText: String, mood:EntryMood)
    {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)
        print(title, bodyText)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, timestamp: NSDate = NSDate(), mood: EntryMood)
    {
        let entry = entry
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = timestamp as Date
        entry.mood = mood.rawValue
        print(title, bodyText)
        saveToPersistentStore()
        put(entry: entry)
    }
    
    func deleteEntry(entry: Entry)
    {
        let entry = entry
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        deleteEntryFromServer(entry: entry)
        do
        {
            try moc.save()
        }
        catch
        {
            moc.reset()
        }
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in })
    {
        let requestURL = baseURL.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTing entry to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
            }
            .resume()
    }
    
    func put(entry:Entry, completion: @escaping CompletionHandler = { _ in })
    {
        let requestURL = baseURL.appendingPathComponent(entry.identifier!).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"//to update existing task
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
        } catch {
            NSLog("Error encoding entry \(entry): \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTing entry to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }
        .resume()
    }
    
    
    
}
