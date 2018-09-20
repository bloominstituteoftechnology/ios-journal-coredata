//
//  Journal+Convinience.swift
//  Journal
//
//  Created by Farhan on 9/17/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation
import CoreData


extension Journal {
    
    convenience init(title: String, notes: String?, timestamp: Date = Date(),identifier:String = UUID().uuidString, mood: String = "😁", context: NSManagedObjectContext = CoreDataStack.shared.mainContext)
    {
        
        self.init(context: context)
        
        self.title = title
        self.notes = notes
        self.timestamp = timestamp
        self.mood = mood
        self.identifier = identifier
        
    }
    
    convenience init?(journalRepresentation: JournalRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        
        self.init(title: journalRepresentation.title, notes: journalRepresentation.notes, timestamp: journalRepresentation.timestamp, identifier: journalRepresentation.identifier, mood: journalRepresentation.mood, context: CoreDataStack.shared.mainContext)
        
    }
    
}
