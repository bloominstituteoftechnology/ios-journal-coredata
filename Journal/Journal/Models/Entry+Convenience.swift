//
//  Entry+Convenience.swift
//  Journal
//
//  Created by David Williams on 4/21/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case ecstatic = "😀"
    case dejected = "😫"
    case meh = "😐"
}

extension Entry {
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        bodyText: String,
                                        timestamp: Date = Date(),
                                        mood: Mood,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood.rawValue
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let identifier = UUID(uuidString: entryRepresentation.identifier) else {
            return nil
        }
  
        self.init(identifier: identifier,
                  title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  mood: entryRepresentation.mood,
                  context: entryRepresentation.context)
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let bodyText = bodyText,
            let timestamp = timestamp,
            let mood = mood else { return  nil }
        
        let id = identifier ?? UUID()
        
        
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let timestampData = try encoder.encode(timestamp)
        } catch {
            NSLog("Oops \(error)")
        }
        
        return EntryRepresentation(identifier: id.uuidString,
                                  title: title,
                                  bodyText: bodyText,
                                  timestamp: timestampData,
                                  mood: mood)
    }
}
