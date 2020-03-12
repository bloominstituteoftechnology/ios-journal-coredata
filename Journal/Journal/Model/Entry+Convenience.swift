//
//  Entry+Convenience.swift
//  Journal
//
//  Created by denis cedeno on 12/4/19.
//  Copyright © 2019 DenCedeno Co. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case happy = "😃"
    case neutral = "😐"
    case sad = "☹️"
    
    static var allMoods: [Mood] {
        return [.happy , .neutral , .sad]
    }
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let timeStamp = timeStamp,
            let mood = mood else { return nil }
        return EntryRepresentation(title: title, bodyText: bodyText, mood: mood, timeStamp: timeStamp, identifier: identifier?.uuidString ?? UUID().uuidString)
    }
    
    convenience init(title: String?,
                     bodyText: String?,
                     mood: String,
                     timeStamp: Date = Date(),
                     identifier: UUID = UUID(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood
        self.timeStamp = timeStamp
        self.identifier = identifier
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = Mood(rawValue: entryRepresentation.mood),
            let identifierString = entryRepresentation.identifier,
            let identifier = UUID(uuidString: identifierString) else { return nil }
        
        self.init(title: entryRepresentation.title,
                  bodyText: entryRepresentation.bodyText,
                  mood: mood.rawValue,
                  timeStamp: entryRepresentation.timeStamp!,
                  identifier: identifier
                  )
    }
}

