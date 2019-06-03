//
//  Entry+Convenience.swift
//  Project
//
//  Created by Ryan Murphy on 6/3/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    convenience init(title: String, bodyText: String, timestamp: Date? = nil, identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContrext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
    

}
