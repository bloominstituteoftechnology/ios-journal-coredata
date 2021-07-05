//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Andrew Ruiz on 10/14/19.
//  Copyright © 2019 Andrew Ruiz. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    // Setting up convenience initializer
    
    // MARK: REMARK - Where would we give the default values? The parameters of the init or inside the self?
    /// Solution: The parameters of the init seems to be the place to put it. https://stackoverflow.com/a/27531637/1291940
    /// Note you would still use self.timestamp = self to make the values are going where they're supposed to.
    @discardableResult convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifer: String = "123", context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        
    }
}
