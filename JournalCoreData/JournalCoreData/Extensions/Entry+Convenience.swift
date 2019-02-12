//
//  Entry+Convenience.swift
//  JournalCoreData
//
//  Created by Nelson Gonzalez on 2/11/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable, Equatable { //all cases array thanks to caseIterable
    case 😊
    case 😐
    case 😞
}

extension Entry {
    convenience init(title: String, bodyText: String, date: Date = Date(), identifier: String = UUID().uuidString, mood: Mood = .😐 , context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = date
        self.identifier = identifier
        self.mood = mood.rawValue
    }
}

extension Entry {
    
    var moodState: Mood {
        
        // in order to get the value
        get {
            return Mood(rawValue: mood!) ?? .😐
        }
        
        set {
            mood = newValue.rawValue
        }
    }
}
