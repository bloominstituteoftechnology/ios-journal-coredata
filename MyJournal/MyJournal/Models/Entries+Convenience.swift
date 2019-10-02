//
//  Entries+Convenience.swift
//  MyJournal
//
//  Created by Eoin Lavery on 02/10/2019.
//  Copyright © 2019 Eoin Lavery. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    convenience init(name: String, bodyText: String, timestamp: Date = Date(), identifier: String = "", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
}
