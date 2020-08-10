//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Craig Belinfante on 8/9/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import Foundation
import CoreData

//@objc(Entry)
//public class Entry: NSManagedObject {
//
//}

extension Entry {
    
    @discardableResult convenience init(mainIdentifier: UUID = UUID(),
                                        title: String,
                                        bodyText: String,
                                        timestamp: Date,
                                        identifier: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.mainIdentifier = mainIdentifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}


