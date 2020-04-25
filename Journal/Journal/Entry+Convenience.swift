//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Morgan Smith on 4/22/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case 😶
    case 😔
    case 😀
}

extension Entry {
    @discardableResult convenience init(title: String,
                                        timestamp: Date,
                                        bodyText: String,
                                        identifier: String = UUID().uuidString,
                                        mood: EntryMood,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        //set up the NSManagaedObject portion of the task object
        self.init(context: context)
        
        //assign our unique values to the attributes we created in the data model file
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
        self.identifier = identifier
        self.mood = mood.rawValue
        
            }
}
