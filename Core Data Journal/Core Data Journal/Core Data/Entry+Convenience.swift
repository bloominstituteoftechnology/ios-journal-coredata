//
//  Entry+Convenience.swift
//  Core Data Journal
//
//  Created by Jaspal on 2/18/19.
//  Copyright © 2019 Jaspal Suri. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID.init().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        // Setting up the NSManagedObject (the Core Data related) part of the Entry object
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
