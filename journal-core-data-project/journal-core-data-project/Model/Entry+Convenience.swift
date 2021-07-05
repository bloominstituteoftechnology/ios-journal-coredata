//
//  Entry+Convenience.swift
//  journal-core-data-project
//
//  Created by Vuk Radosavljevic on 8/13/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import Foundation
import CoreData


enum Mood: String {
    
    
    case happy = "😀"
    case neutral = "😐"
    case sad = "☹️"
    
    static var allMoods: [Mood] {
        return [.happy, .neutral, .sad]
    }
}



extension Entry {
    
    convenience init(title: String, bodyText: String, mood: Mood.RawValue, managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: managedObjectContext)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = Date()
        self.identifier = UUID().uuidString
        self.mood = mood
    }
    
    
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, mood: entryRepresentation.mood)
    }
}
