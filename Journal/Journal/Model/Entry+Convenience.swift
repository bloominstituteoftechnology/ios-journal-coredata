//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jake Connerly on 8/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String, identifier: String?, timeStamp: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timeStamp = timeStamp
    }
}

