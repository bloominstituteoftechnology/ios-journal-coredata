//
//  Journal+Convinience.swift
//  Journal
//
//  Created by Farhan on 9/17/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation
import CoreData


extension Journal {
    
    convenience init(title: String, notes: String?, timestamp: Date = Date(),identifier:String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext)
    {
        
        self.init(context: context)
        
        self.title = title
        self.notes = notes
        self.timestamp = timestamp
        
    }
    
}
