//
//  Entry+Convenience.swift
//  JournalCoreData
//
//  Created by John Holowesko on 2/14/20.
//  Copyright © 2020 John Holowesko. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Extension

extension Entry {
    @discardableResult
    convenience init(title: String, bodyText: String? = "", timestamp: Date? = Date(), indentifier: String? = "new", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
        self.identifier = indentifier
    }
}
