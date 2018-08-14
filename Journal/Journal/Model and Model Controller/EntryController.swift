//
//  EntryController.swift
//  Journal
//
//  Created by Andrew Liao on 8/13/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import Foundation
import CoreData

enum MoodType:String {
    case sad = "🙁"
    case neutral = "😐"
    case happy = "🙂"
    
    static var types = [sad, neutral,happy]
}
class EntryController{
    //MARK: - CRUD Methods
    func create(withTitle title: String, bodyText text:String? = nil, mood:String){
        let _ = Entry(title: title, bodyText: text, mood:mood)
        saveToPersistentStore()
    }
    
    func update(forEntry entry: Entry, withTitle title: String, bodyText text:String, mood: String){
        entry.title = title
        entry.bodyText = text
        entry.timeStamp = Date()
        entry.mood = mood
        saveToPersistentStore()
    }
    
    func delete(entry: Entry){
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        saveToPersistentStore()
    }
    //MARK: - Networking
    func saveToPersistentStore(){
        let moc = CoreDataStack.shared.mainContext
        do{
            try moc.save()
        } catch {
            NSLog("Trouble saving: \(error)")
            moc.reset()
        }
    }
    
//    func loadFromPersistentStore() -> [Entry]{
//        //creates a fetch request that is specific to Entry
//        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
//        let moc = CoreDataStack.shared.mainContext
//        let loadedEntries:[Entry]
//        
//        do {
//            loadedEntries = try moc.fetch(request)
//        } catch {
//            NSLog("Error loading from persistent store: \(error)")
//            return [Entry]()
//        }
//        return loadedEntries
//    }
    
    //MARK: - Properties
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//    }
}
