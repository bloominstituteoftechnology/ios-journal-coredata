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
    
    var journal: [Journal]{
        
        let request: NSFetchRequest<Journal> = Journal.fetchRequest()
        
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(request)
        } catch{
            NSLog("Tasks FETCH failed: \(error)")
            return []
        }
    
    }
    
    
    func createJournalEntry(with title: String, and notes: String?, mood: String){
        
        _ = Journal(title: title, notes: notes, mood: mood)
        saveToPersistentStorage()
        
    }
    
    func updateJournalEntry(entry: Journal, with title:String, and notes: String?, mood: String){
        
        entry.title = title
        entry.notes = notes
        entry.mood = mood
        saveToPersistentStorage()
        
    }
    
    func deleteJournalEntry(entry: Journal){
        
        let moc = CoreDataStack.shared.mainContext
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
    
    
    
}
