//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Yvette Zhukovsky on 11/5/18.
//  Copyright © 2018 Yvette Zhukovsky. All rights reserved.
//

import Foundation
import CoreData


extension Entry{
    
    convenience init(title: String, bodytext: String, timestamp:Date = Date(), identifier: String = UUID().uuidString, context:NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        self.init(context:context)
        self.title = title
        self.bodytext = bodytext
        self.timestamp = timestamp
        self.identifier = identifier
        
        
        
    }
}
