//
//  Jornal+Convenience.swift
//  Journal
//
//  Created by Alex Rhodes on 9/16/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation
import CoreData

extension Journal {
    
    
    convenience init(title: String, bodyText: String, identifier: String?, time: Date, context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.title = title
        self.identifier = identifier
        self.bodyText = bodyText
        self.time = time
        
    }
    
    
}
