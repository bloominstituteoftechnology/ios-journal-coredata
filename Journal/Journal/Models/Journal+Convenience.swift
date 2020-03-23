//
//  Journal+Convenience.swift
//  Journal
//
//  Created by Lambda_School_Loaner_259 on 3/23/20.
//  Copyright © 2020 DeVitoC. All rights reserved.
//

import Foundation
import CoreData

extension Journal {
    @discardableResult convenience init(identifier: UUID = UUID(),
                     title: String,
                     entry: String?,
                     date: Date,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.entry = entry
        self.date = date 
    }
    
}
