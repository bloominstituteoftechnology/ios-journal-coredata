//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Waseem Idelbi on 4/22/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import UIKit
import CoreData

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String, timestamp: Date, identifier: String = UUID().uuidString, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
}
