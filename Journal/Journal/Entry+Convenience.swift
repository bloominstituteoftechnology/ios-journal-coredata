//
//  Entry+Convenience.swift
//  Journal
//
//  Created by ronald huston jr on 7/12/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    @discardableResult convenience init(id: String = "xyz",
                     title: String,
                     bodyText: String,
                     timestamp: Date,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.id = id
        self.title = title
        self.bodyText = bodyText
    }
    
}
