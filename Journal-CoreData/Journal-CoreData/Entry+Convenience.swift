//
//  Entry+Convenience.swift
//  Journal-CoreData
//
//  Created by Jerrick Warren on 11/7/18.
//  Copyright © 2018 Jerrick Warren. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String,
                     bodyText: String,
                     timeStamp: Date,
                     identifier: String,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
    }
}
