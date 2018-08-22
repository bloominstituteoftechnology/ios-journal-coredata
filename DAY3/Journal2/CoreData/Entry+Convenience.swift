//
//  Entry+Convenience.swift
//  Journal2
//
//  Created by Carolyn Lea on 8/21/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import Foundation
import CoreData

extension Entry
{
    convenience init(title: String, bodyText: String, identifier:String = UUID().uuidString, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext)
    {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timestamp = timestamp
    }
}
