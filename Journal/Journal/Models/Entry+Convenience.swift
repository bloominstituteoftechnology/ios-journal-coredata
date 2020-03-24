//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Bradley Diroff on 3/23/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(identifier: String = UUID().uuidString,
                     title: String,
                     bodyText: String,
                     timeStamp: Date = Date(),
                     context: NSManagedObjectContext) {
        
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        
    }
}
