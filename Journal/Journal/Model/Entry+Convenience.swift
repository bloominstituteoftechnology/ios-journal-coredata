//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jarren Campos on 4/22/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(identifier: String,
                                        bodyText: String,
                                        timestamp: Date,
                                        title: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
    
    self.init(context: context)
        self.identifier = identifier
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.title = title
}
}
