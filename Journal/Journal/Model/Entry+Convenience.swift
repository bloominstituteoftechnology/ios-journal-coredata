//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jessie Ann Griffin on 10/1/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(
        title: String, bodyText: String? = nil, timeStamp: Date, identifier: String,
        context: NSManagedObjectContext = CoreDataStack.shared.mainContext)
    {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
    }
}
