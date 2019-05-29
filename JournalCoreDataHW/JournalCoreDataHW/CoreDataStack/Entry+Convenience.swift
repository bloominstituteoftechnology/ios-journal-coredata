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
    
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, mood: EntryMood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        //initialize the object in the context
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
    
    //Decoder: Json -> EntryRepresentation -> Entry
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        //because we have properties that can return nil we have to unwrap them
        guard let mood = EntryMood(rawValue: entryRepresentation.mood) else { return nil }
        
        //pass the EntryRepresentation as arguments to initialize the entryRepresentation
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, timestamp: entryRepresentation.timestamp, identifier: entryRepresentation.identifier, mood: mood, context: context)
    }
    
    //Encoder: Entry -> EntryRepresentation -> JSON
    var entryRepresentation: EntryRepresentation? {
        //unwrap core data properties that are in the intializer to create or model, so in this case its title, bodytext and mood. ( check out createFunction )
        guard let title = title, let bodyText = bodyText, let mood = mood , let identifier = identifier else { return nil }
        return EntryRepresentation(title: title, bodyText: bodyText, timestamp: timestamp ?? Date(), identifier: identifier, mood: mood)
    }
}
