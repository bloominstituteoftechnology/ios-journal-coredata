//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jeremy Taylor on 6/3/19.
//  Copyright © 2019 Bytes Random L.L.C. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String, mood: String, timestamp: Date = Date(), identifer: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood
        self.timestamp = timestamp
        self.identifier = identifer
        
    }
}
