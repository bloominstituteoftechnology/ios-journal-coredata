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
    
    @discardableResult convenience init?(er: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let mood = Mood(rawValue: er.mood) else {return nil}
        
        self.init(title: er.title, bodyText: er.bodyText,
                  date: er.timestamp, identifier: er.identifier,
                  mood: mood, context: context)
        
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title, let bodyText = bodyText, let date = timestamp, let identifier = identifier, let mood = mood else {return nil}
        
        
        return EntryRepresentation(title: title, bodyText: bodyText, timestamp: date, identifier: identifier, mood: mood)
    }
    
}
