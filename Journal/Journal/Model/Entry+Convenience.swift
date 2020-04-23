//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Elizabeth Thomas on 4/22/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    @discardableResult convenience init(identifier: String,
                                        title: String,
                                        bodyText: String,
                                        timestamp: Date,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
    }
    
}
