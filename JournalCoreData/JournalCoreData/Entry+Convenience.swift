//
//  Entry+Convenience.swift
//  JournalCoreData
//
//  Created by Bhawnish Kumar on 4/20/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                     title: String,
                     bodyText: String,
                     timeStamp: Date,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
    }
    
}
