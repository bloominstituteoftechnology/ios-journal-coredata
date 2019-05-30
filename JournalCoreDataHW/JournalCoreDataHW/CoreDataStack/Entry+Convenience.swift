//
//  Entry+Convenience.swift
//  JournalCoreDataHW
//
//  Created by Michael Flowers on 5/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String {
    case happy = "😃"
    case chillin = "😐"
    case sad = "😟"
    
    static var allMoods: [EntryMood] {
        return [.happy, .chillin, .sad]
    }
}

extension Entry {
    //creates an entry and puts it into core data
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, mood: EntryMood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        //initialize the object in the context
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
    
    //Decoder: Json -> EntryRepresentation -> Entry (into core data) -this initializes the entry because we are getting it back from JSON it could be something else/or nil.
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        //because we have properties that can return nil we have to unwrap them
        guard let mood = EntryMood(rawValue: entryRepresentation.mood) else { return nil }
        
        //We are using the entryRepresentation data we received from JSON and now we are using its properties to initialize an Entry with core data.
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, timestamp: entryRepresentation.timestamp, identifier: entryRepresentation.identifier, mood: mood, context: context)
    }
    
    //Encoder: Entry -> EntryRepresentation -> JSON
    var entryRepresentation: EntryRepresentation? {
        //unwrap core data properties --which are optiionals-- bc we are using the properties of an entry/with core data, to initialize an entryRepresentation
        guard let title = title, let bodyText = bodyText, let mood = mood, let identifier = identifier else { return nil }
        return EntryRepresentation(title: title, bodyText: bodyText, timestamp: timestamp ?? Date(), identifier: identifier, mood: mood)
    }
}
