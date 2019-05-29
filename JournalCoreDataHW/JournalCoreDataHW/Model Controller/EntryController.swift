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
    
    
    //commenting out so that we can use the nsfrc
//    var entries: [Entry] {
//        //This will allow any changes to the persistent store to become immediately visible to the user when accessing this array, like in the talbe view showing list of entries.
//        return loadFromPersistentStore()
//    }
    
    func createEntry(title: String, bodyText: String, mood: EntryMood){
        let _ = Entry(title: title, bodyText: bodyText, mood: mood)
        
        saveToPersistentStore()
    }
    
    func update(entry: Entry, newTitle: String, newBodyText: String, newTimestamp: Date, newMood: EntryMood){
        entry.title = newTitle
        entry.bodyText = newBodyText
        entry.timestamp = newTimestamp
        entry.mood = newMood.rawValue
        
        saveToPersistentStore()
    }
    
    func delete(entry: Entry){
        CoreDataStack.shared.mainContext.delete(entry)
        
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
    
    //commenting out so that we can use the nsfrc
//    func loadFromPersistentStore() -> [Entry] {
//        let moc = CoreDataStack.shared.mainContext
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//
//        do {
//            let results = try moc.fetch(fetchRequest)
//            return results
//        } catch  {
//            print("Error with in the load from persistent store function: \(error.localizedDescription)")
//        }
//        return []
//    }

    //MARK: - API CALLS
    let baseURL = URL(string: "https:journalcd-f7246.firebaseio.com/")!
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void){
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
//           requestURL.httpBody = try JSONEncoder().encode(entry)
        } catch  {
            print("Error putting the entry into the httpbody: \(error.localizedDescription)")
            completion(error)
            return
        }
    }
}


