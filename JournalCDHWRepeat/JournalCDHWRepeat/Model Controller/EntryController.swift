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
    
    
    func createEntry(title: String, bodyText: String, mood: EntryMood){
        let _ = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, newTitle: String, newBody: String, newTimestamp: Date = Date(), newMood: EntryMood){
        entry.title = newTitle
        entry.bodyText = newBody
        entry.timestamp = newTimestamp
        entry.mood = newMood.rawValue
        saveToPersistentStore()
    }
    
    func delete(entry: Entry){
        CoreDataStack.shared.mainContext.delete(entry)
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
        guard let identifier = entry.identifier else { print("error with identifier"); return }
        let url = baseUrl.appendingPathComponent(identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        
    }
}
