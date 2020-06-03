//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Clayton Watkins on 6/3/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    @discardableResult convenience init(identifier: String,
                                        timestamp: Date,
                                        title: String,
                                        bodyText: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        self.init(context: context)
        self.identifier = identifier
        self.timestamp = timestamp
        self.title = title
        self.bodyText = bodyText
    }
}

