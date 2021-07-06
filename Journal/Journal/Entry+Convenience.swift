//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Kobe McKee on 6/3/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    convenience init(title: String, bodyText: String, timeStamp: Date? = Date(), identifier: String? = "1", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
        
    }
    
    
}
