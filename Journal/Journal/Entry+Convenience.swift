//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Lambda_School_Loaner_218 on 12/16/19.
//  Copyright © 2019 Lambda_School_Loaner_218. All rights reserved.
//

import CoreData
import Foundation

extension Entry {
   convenience init(title: String, bodyText: String? = nil , timestamp: Date = Date(), identifier: String = UUID().uuidString , context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.bodytext = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
