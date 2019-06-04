//
//  Entry+Convenience.swift
//  JournalCDHWRepeat
//
//  Created by Michael Flowers on 6/3/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String {
    case sad = "😟"
    case neutral = "😐"
    case happy = "😃"
    
    static var allMoods: [EntryMood] {
        return [.sad, .neutral, .happy]
    }
}


extension Entry {
    
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identiifier: String = UUID().uuidString, mood: EntryMood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identiifier
        self.mood = mood.rawValue
    }
    
    //this should take an EntryRepresentation parameter and initialize an Entry
    //Json -> EntryRepresentation -> Entry
    convenience init?(entryRepresentation: EntryRepresentation){
        guard let mood = EntryMood(rawValue: entryRepresentation.mood) else { return nil }
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, timestamp: entryRepresentation.timestamp, identiifier: entryRepresentation.identifier, mood: mood) //leaving out context for now
    }
    
    //this computed property should convert an entry to a entryRep
    //Entry -> EntryRepresentation -> JSON
    //this should simply return an entryRepresentation object that is intialized from the values of the entry.
    var entryRep: EntryRepresentation? {
        guard let title = title, let bodyText = bodyText, let identifier = identifier, let mood = mood else { return nil }
        return EntryRepresentation(title: title, bodyText: bodyText, timestamp: timestamp ?? Date(), identifier: identifier, mood: mood)
    }
}
