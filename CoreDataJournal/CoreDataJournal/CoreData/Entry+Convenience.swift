//
//  Entry+Convenience.swift
//  CoreDataJournal
//
//  Created by Benjamin Hakes on 1/14/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String,
                     bodyText: String? = nil,
                     timestamp: Date = Date(),
                     identifier: UUID = UUID(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        self.init(context:context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        
    }
}
