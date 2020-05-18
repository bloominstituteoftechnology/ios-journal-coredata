//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Kelson Hartle on 5/17/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(identifier: String = String(),
                                        bodyText: String,
                                        timeStamp: Date? = Date(),
                                        title: String,
                                        complete: Bool = false,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.identifier = identifier
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.title = title
        self.complete = complete
        
        
    }
    
    
    
}
