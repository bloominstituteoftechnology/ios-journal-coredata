//
//  EntryController.swift
//  Journal CoreData
//
//  Created by Iyin Raphael on 9/25/18.
//  Copyright © 2018 Iyin Raphael. All rights reserved.
//

import Foundation
import CoreData

class EntryController{
    
    //MARK:- CRUD
    
    func loadToPesrsistence() ->[Entry]{
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        do{
            return try moc.fetch(fetchRequest)
        }catch{
            NSLog( "Error occured while trying to fetch data from Persistence Store: \(error)")
            return []
        }
    }
    
    func saveToPesistence(){
        do{
            try moc.save()
        }catch{
            moc.reset()
            NSLog("Error saving managed object context\(error)")
        }
    }
    
    
    func createEntry(title: String, bodyText: String, mood: moodType){
        let _ = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPesistence()
    }
    
    func updateEntry(entry: Entry, title: String, bodyText: String, date: Date = Date(), mood: String){
        entry.title = title
        entry.bodyText = bodyText
        entry.date = date
        entry.mood = mood
        saveToPesistence()
    }
    
    func delete(entry: Entry){
        moc.delete(entry)
        saveToPesistence()
    }
    
    var entries: [Entry] {
        return loadToPesrsistence()
    }
    
    
    
}
