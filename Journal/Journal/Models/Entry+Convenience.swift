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
                                        mood: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.mood = mood
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let identifier = UUID(uuidString: entryRepresentation.identifier) else {
            return nil
        }
        // convert string to date
        self.init(identifier: identifier,
                  title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timestamp: entryRepresentation.timestamp,
                  mood: entryRepresentation.mood)
                 
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let bodyText = bodyText,
            let timeStamp = timestamp,
            let id = identifier,
            let mood = mood else { return  nil }

      
        
        return EntryRepresentation(identifier: id.uuidString,
                                  title: title,
                                  bodyText: bodyText,
                                  timestamp: timeStamp,
                                  mood: mood)
    }
}

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.string(from: self)
    }
}
