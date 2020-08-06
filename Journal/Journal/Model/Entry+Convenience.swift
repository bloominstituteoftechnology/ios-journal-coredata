//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Eoin Lavery on 06/08/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(identifier: String = String(describing: UUID()),
                                        title: String,
                                        bodyText: String,
                                        timestamp: Date = Date(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timestamp = timestamp
    }
}
