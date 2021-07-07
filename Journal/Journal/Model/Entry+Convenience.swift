//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Bradley Yin on 8/19/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(title: String, bodyText: String, timeStamp: Date, identifier: UUID = UUID(), mood: Int64, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
        self.mood = mood
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let title = entryRepresentation.title, let bodyText = entryRepresentation.bodyText, let timeStamp = entryRepresentation.timeStamp, let identifier = entryRepresentation.identifier, let mood = entryRepresentation.mood else { return nil }
        self.init(title: title, bodyText: bodyText, timeStamp: timeStamp, identifier: identifier, mood: mood, context: context)
    }
    
    var entryRepresentation: EntryRepresentation {
        return EntryRepresentation(mood: mood, bodyText: bodyText, identifier: identifier, title: title, timeStamp: timeStamp)
    }
}
