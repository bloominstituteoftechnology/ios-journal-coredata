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
    
    @discardableResult convenience init?(taskRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
    }
}
