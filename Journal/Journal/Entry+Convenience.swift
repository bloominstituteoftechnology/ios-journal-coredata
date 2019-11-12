//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Lambda_School_Loaner_204 on 11/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String,
                     timestamp: Date,
                     mood: String = "😐",
                     bodyText: String? = nil,
                     identifier: String? = nil,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.timestamp = timestamp
        self.mood = mood
        self.bodyText = bodyText
        self.identifier = identifier
    }
}
