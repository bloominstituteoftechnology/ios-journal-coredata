//  Copyright © 2019 Frulwinn. All rights reserved.

import Foundation
import CoreData

class EntryController {
    
    let baseURL = URL(string: "https://test-82e39.firebaseio.com/")!
    
    //MARK: - Properties

    
    func saveToPersistentStore() {
        //save core data stack's mainContext, bundle the changes
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func create(title: String, bodyText: String, mood: JournalMood) {
        Entry(title: title, bodyText: bodyText, mood: mood)
        
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
       
        saveToPersistentStore()
    }
}
