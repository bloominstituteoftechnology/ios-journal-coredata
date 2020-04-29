//
//  Journal+Convenience.swift
//  Journal
//
//  Created by Breena Greek on 4/22/20.
//  Copyright © 2020 Breena Greek. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy = "😃"
    case neutral = "😐"
    case sad = "☹️"
}

extension Entry {
    @discardableResult convenience init(title: String,
                                        bodyText: String,
                                        timeStamp: Date = Date(),
                                        identifier: UUID = UUID(),
                                        mood: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.timeStamp = timeStamp
        self.identifier = identifier
        self.bodyText = bodyText
        self.mood = mood
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let identifier = UUID(uuidString: entryRepresentation.identifier) else {
                      return nil
              }
                
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  timeStamp: entryRepresentation.timeStamp,
                  identifier: identifier,
                  mood: entryRepresentation.mood)
    }
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let mood = mood,
            let body = bodyText,
            let identifier = identifier?.uuidString,
            let timeStamp = timeStamp else { return nil }
        
        return EntryRepresentation(title: title,
                                   bodyText: body,
                                   timeStamp: timeStamp,
                                   identifier: identifier,
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
