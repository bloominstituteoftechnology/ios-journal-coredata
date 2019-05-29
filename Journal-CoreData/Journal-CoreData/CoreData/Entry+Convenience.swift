//
//  Entry+Convenience.swift
//  Journal-CoreData
//
//  Created by Sameera Roussi on 5/27/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import Foundation
import CoreData

enum Moods: String {
    case 😩
    case 😐
    case 🤪
    
    static var allMoods: [Moods] {
        return [.😩, .😐, .🤪]
    }
}

extension Entry {
    convenience init(identifier: String = UUID().uuidString,
                     title: String,
                     bodyText: String,
                     mood: Moods,
                     timestamp: Date = Date(),
                     context: NSManagedObjectContext = JournalCoreDataStack.shared.mainContext) {
        
        // A managed context MUST be provided when a Core Data object is initialized.
        // A Core Data Object can not exsit outside of a Managed Object Context
        // The main context in Core Data is viewContext
        
        // Call the Entry class' initializer that takes in an NSManagedObjectContext
        // This is ONLY setting up the NSManagedObject part of the Entry class.
        // It is setting up a generic MOC
        self.init(context: context)
        
        // Set the value of attributes defined in the data model
        self.identifier = identifier
        self.title = title
        self.timestamp = timestamp
        self.mood = mood.rawValue
        self.bodyText = bodyText
    }
    
}
