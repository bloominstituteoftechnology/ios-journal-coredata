//
//  Entry+Convenience.swift
//  Journal CoreData
//
//  Created by Iyin Raphael on 9/24/18.
//  Copyright © 2018 Iyin Raphael. All rights reserved.
//

import Foundation
import CoreData

extension Entry{
    
    convenience init(title: String, bodyText: String, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.date = date 
        
    }
}
