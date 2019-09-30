//
//  Entry+Convenience.swift
//  Journal
//
//  Created by John Kouris on 9/30/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    convenience init(title: String, bodyText: String?, identifier: String = "default", timestamp: Date = Date(), context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timestamp = timestamp
    }
    
}
