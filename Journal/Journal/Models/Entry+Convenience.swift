//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Enzo Jimenez-Soto on 5/18/20.
//  Copyright © 2020 Enzo Jimenez-Soto. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                     title: String,
                     bodyText: String,
                     timeStamp: Date,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
    }
    
}
