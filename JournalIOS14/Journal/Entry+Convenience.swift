//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Ufuk Türközü on 24.02.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String,
                     timestamp: Date,
                     bodyText: String,
                     id: String,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
        self.id = id
    }
}
