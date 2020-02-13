//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Joshua Rutkowski on 2/12/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String?, timestamp: Date, identifer: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
