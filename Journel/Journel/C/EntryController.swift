//
//  EntryController.swift
//  Journel
//
//  Created by Nathan Hedgeman on 8/22/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "Delete"
    case put = "PUT"
}

class EntryController {
    
    //Properties
    let baseURL = URL(string: "https://journal-coredata-project.firebaseio.com/")!
    //    var entries: [Entry] {
    //        // this adds the stored data to the "source of all truth"
    //        //remember computed properties need to RETURN a value. So this "return" returns the value that is retuned in the loadFromPersistentStore function
    //        return loadFromPersistentStore()
    //    }
}


//MARK: - MOC functions
extension EntryController {
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving MOC: \(error)")
            moc.reset()
        }
    }
    
    //    func loadFromPersistentStore() -> [Entry] {
    //        let moc = CoreDataStack.shared.mainContext
    //        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
    //
    //        do {
    //            return try moc.fetch(fetchRequest)
    //        } catch {
    //            NSLog("Error fetching MOC: \(error)")
    //        }
    //        saveToPersistentStore()
    //        return []
    //    }

//CRUD
    func create(title: String, bodyText: String?, mood: String ) {
        _ = Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String?, updatedTimeStamp: Date = Date(), mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.timeStamp = updatedTimeStamp
        entry.mood = mood
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
}

//MARK: - Network Functions
extension EntryController {
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void = { _ in }) {
        
        let id = entry.identifier?.uuidString ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            guard var representation = entry.entryRepresentation else {completion(NSError()); return}
            representation.identifier = UUID(uuidString: id)!
            self.saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("EntryController: Put Method : Entry: (\(entry)), not encoded")
            completion(error)
            return
        }
    }
    
}
