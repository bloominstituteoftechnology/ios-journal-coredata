//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Ian French on 6/3/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import Foundation
import CoreData


enum Mood: String, CaseIterable {
    case sad =  "😢"
    case neutral = "😐"
    case happy = "😊"
}



extension Entry {
    
    @discardableResult convenience init(title: String, timestamp: Date = Date(), mood: Mood = .neutral, identifier: String = "\(UUID.self)", bodyText: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext)  {
        
        self.init(context: context)
        self.title = title
        self.timestamp = timestamp
        self.identifier = identifier
        self.bodyText = bodyText
        self.mood = mood.rawValue
    }
    
}


