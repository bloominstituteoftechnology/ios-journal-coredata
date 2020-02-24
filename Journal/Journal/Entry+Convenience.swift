//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Lambda_School_Loaner_268 on 2/24/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String, timeStamp: Date = Date() , identifier: String = "", bodyText: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.timeStamp = timeStamp
        self.identifier = identifier
        self.bodyText = bodyText
    }
}
