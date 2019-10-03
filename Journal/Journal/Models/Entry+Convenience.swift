//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Vici Shaweddy on 10/2/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String? = nil, timestamp: Date = Date(), identifier: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
