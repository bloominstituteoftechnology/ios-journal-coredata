//
//  Entry+Conveinence.swift
//  Journal
//
//  Created by Alex Thompson on 12/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String,
                     bodyTitle: String,
                     timestamp: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyTitle = bodyTitle
        self.timestamp = timestamp
    }
}
