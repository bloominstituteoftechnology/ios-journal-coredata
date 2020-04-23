//
//  Journal+Convenience.swift
//  Journal
//
//  Created by Breena Greek on 4/22/20.
//  Copyright © 2020 Breena Greek. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(title: String,
                     bodyText: String,
                     timeStamp: Date = Date(),
                     identifier: UUID = UUID(),
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.timeStamp = timeStamp
        self.identifier = identifier
    }
}
