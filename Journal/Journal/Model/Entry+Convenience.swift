//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Kat Milton on 7/22/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String? = nil, timeStamp: Date? = Date(), identifier: String? = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
        
    }
    
    
    
    
}
