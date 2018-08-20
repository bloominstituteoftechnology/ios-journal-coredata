//
//   Entry+Convenience.swift
//  Journal CoreData
//
//  Created by Ngozi Ojukwu on 8/20/18.
//  Copyright © 2018 iyin. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    convenience init(name: String, bodyText: String, timestamp: Date = Date() , identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        self.init(context:context)
        self.name = name
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        
    }
    
}
