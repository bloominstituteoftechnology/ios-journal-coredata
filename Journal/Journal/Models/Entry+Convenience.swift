//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Bradley Diroff on 3/23/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import Foundation
import CoreData

enum FaceValue: String, CaseIterable {
    case 🙁
    case 😐
    case 🙂
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        
        guard let identifier = identifier,
        let title = title,
        let timeStamp = timeStamp,
            let mood = mood else {return nil}
        
        return EntryRepresentation(identifier: identifier, title: title, bodyText: bodyText, timeStamp: DateFormatter.shortFormatter.string(from: timeStamp), mood: mood)
    }
    
    @discardableResult convenience init(identifier: String = UUID().uuidString,
                     title: String,
                     bodyText: String,
                     timeStamp: Date = Date(),
                     mood: FaceValue = .😐,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.mood = mood.rawValue
        
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let date = DateFormatter.shortFormatter.date(from: entryRepresentation.timeStamp),
            let bText = entryRepresentation.bodyText,
            let mood = FaceValue(rawValue: entryRepresentation.mood)
        else {return nil}
        
        self.init(identifier: entryRepresentation.identifier, title: entryRepresentation.title, bodyText: bText, timeStamp: date, mood: mood)
        
    }
}
