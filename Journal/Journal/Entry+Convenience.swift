//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Rick Wolter on 11/11/19.
//  Copyright © 2019 Richar Wolter. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    
    convenience init(title: String, bodyText: String? = nil, timestamp: Date, indentifier: String? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
        self.identifier = identifier
     
        
    }
    
}
