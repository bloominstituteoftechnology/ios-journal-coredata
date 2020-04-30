//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Lambda_School_loaner_226 on 4/28/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(title: String,
                                        bodyText: String,
                                        timeStamp: Date,
                                        identifier: String,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
    }
}
