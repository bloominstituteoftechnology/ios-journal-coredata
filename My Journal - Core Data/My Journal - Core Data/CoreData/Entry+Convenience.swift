//
//  Entry+Convenience.swift
//  My Journal - Core Data
//
//  Created by Nick Nguyen on 2/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation
import CoreData

 extension Entry {
     convenience init(title: String, bodyText: String ,timestamp: Date = Date(), identifier : String = "", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context:context)
        self.title = title
        self.bodyText = bodyText
        
    }
}
