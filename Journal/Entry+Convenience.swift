//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Dojo on 8/5/20.
//  Copyright © 2020 Dojo. All rights reserved.
//

import UIKit
import CoreData

extension Entry {
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        bodyText: String?,
                                        timeStamp: Date,
                                        title: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext
    ) {
        self.init(context: context)
        self.identifier = identifier
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.title = title
    }
}
