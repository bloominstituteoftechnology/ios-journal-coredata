//
//  Entry+Convenience.swift
//  Journal (Core Data)
//
//  Created by Julian A. Fordyce on 2/18/19.
//  Copyright © 2019 Glas Labs. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    convenience init(bodyText: String, title: String, timeStamp: Date = Date(), identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)

        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.title = title
        self.identifier = identifier
    }
    
    
    
    
    
    
    
    
    
}
