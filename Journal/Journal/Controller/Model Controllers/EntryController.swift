//
//  EntryController.swift
//  Journal
//
//  Created by Kenny on 1/27/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import CoreData

enum MoodType: String {
    case sad = "😢"
    case neutral = "😑"
    case happy = "🤣"
    static var allMoods: [MoodType] {
        return [.sad, .neutral, .happy]
    }
}

class EntryController {
    //MARK: Properties
    typealias CompletionHandler = (Error?) -> ()
    let save = {
        CoreDataStack.shared.saveToPersistentStore()
    }
    private let baseURL = "https://lambda-journal-f748d.firebaseio.com/"
    let context = CoreDataStack.shared.mainContext
    
    //MARK: Create
    func createEntry(title: String, bodyText: String, mood: MoodType) {
        let _ = Entry(title: title, bodyText: bodyText, timestamp: Date(), identifier: UUID(), mood: mood.rawValue)
        save()
    }
    
    func put(entry: Entry, complete: CompletionHandler) {
        
    }
        
    //MARK: Update
    func updateEntry(newTitle: String, newBodyText: String, entry: Entry, mood: MoodType) {
        entry.title = newTitle
        entry.bodyText = newBodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        save()
    }
    
    //MARK: Delete
    func deleteEntry(entry: Entry) {
        context.delete(entry)
        save()
    }
    
}
