//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Cameron Collins on 4/20/20.
//  Copyright © 2020 Cameron Collins. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(identifier: String = "No ID", title: String = "No Title", bodyText: String = "No Description", timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        //Standard init
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
    }
}
 
