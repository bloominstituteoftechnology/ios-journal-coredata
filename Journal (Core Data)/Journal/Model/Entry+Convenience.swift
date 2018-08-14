//
//  Entry+Convenience.swift
//  Journal (Core Data)
//
//  Created by Linh Bouniol on 8/13/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String, mood: String, managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: managedObjectContext)
        
        self.title = title
        self.bodyText = bodyText
        self.mood = mood
        self.timestamp = Date()
        self.identifier = UUID().uuidString
        
        // By not setting up a way to change properties via initializer arguments, we prevent users of the initializer from modifying those properties.
        
    }
}

enum Mood: String {
    case 😀
    case 😐
    case 😢
    
    static var allMoods: [Mood] {
        return [.😀, .😐, .😢]
    }
}
