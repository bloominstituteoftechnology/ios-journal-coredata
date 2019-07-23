//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Kat Milton on 7/22/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case 😁
    case 😐
    case 🥺
    
    static var allMoods: [Mood] {
        return [.😁, .😐, .🥺]
    }
}

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String? = nil, timeStamp: Date? = Date(), identifier: String? = UUID().uuidString, mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
        self.mood = mood.rawValue
        
    }
    
    
    
    
}
