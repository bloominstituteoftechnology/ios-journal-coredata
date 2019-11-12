//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Dennis Rudolph on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(name: String, description: String? = nil, time: Date, identification: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = name
        self.timestamp = time
        self.bodyText = description
        self.identifier = identification
    }
}
