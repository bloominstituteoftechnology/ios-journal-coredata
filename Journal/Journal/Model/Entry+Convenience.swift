//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Clayton Watkins on 6/3/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable{
    case 🥺
    case 😐
    case 😃
}

extension Entry {
    
    @discardableResult convenience init(identifier: String,
                                        timestamp: Date,
                                        title: String,
                                        bodyText: String,
                                        mood: Mood = .😐,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        self.init(context: context)
        self.identifier = identifier
        self.timestamp = timestamp
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.rawValue
    }
}

