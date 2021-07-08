//
//   Entry+Convenience.swift
//  Journal CoreData
//
//  Created by Ngozi Ojukwu on 8/20/18.
//  Copyright © 2018 iyin. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String {
    case sad
    case neutral
    case happy
   
    
    static var allMoods: [EntryMood]{
        return [.sad, .neutral, .happy]
    }
}

extension Entry {
    
    convenience init(name: String, bodyText: String, timestamp: Date = Date() , identifier: String = UUID().uuidString, mood: EntryMood = .neutral,  context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        self.init(context:context)
        self.name = name
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
        
    }
    
}
