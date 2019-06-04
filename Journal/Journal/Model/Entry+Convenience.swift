//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Sameera Roussi on 6/3/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        (self.title, self.bodyText, self.timestamp, self.identifier) = (title, bodyText, timestamp, identifier)
    }
}

