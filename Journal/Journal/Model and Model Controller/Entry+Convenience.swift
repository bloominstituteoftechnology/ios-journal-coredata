//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Andrew Liao on 8/13/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String? = nil, timeStamp: Date = Date(), mood:String,
                     identifier: String = UUID().uuidString,  context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        //Uses the designated initializer the intialize the Entry object
        self.init(context: context)
        //Sets the properties according to the parameters of the convenience initializer
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
        self.mood = mood
        
    }
    
    convenience init?(entryRepresentation: EntryRepresentation){
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timeStamp: entryRepresentation.timeStamp,
                  mood: entryRepresentation.mood,
                  identifier: entryRepresentation.identifier)
    }
}

