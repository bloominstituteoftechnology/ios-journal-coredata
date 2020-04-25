//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Bree Jeune on 4/24/20.
//  Copyright © 2020 Young. All rights reserved.
//

import Foundation

import CoreData

extension Entry {
    
    convenience init(title: String, bodyText: String, identifier: String = UUID().uuidString, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier

    }
    
}
