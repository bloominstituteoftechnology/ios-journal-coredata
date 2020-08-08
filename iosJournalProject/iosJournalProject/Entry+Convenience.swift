//
//  Entry+Convenience.swift
//  iosJournalProject
//
//  Created by BrysonSaclausa on 8/5/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        timestamp: Date = Date(),
                                        bodyText: String,
                                        context: NSManagedObjectContext  = CoreDataStack.shared.mainContext) {

                                        
                                        
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
    }
                                        
    
}
