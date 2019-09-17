//
//  Entry+Convenience.swift
//  JournalCoreData
//
//  Created by Marc Jacques on 9/16/19.
//  Copyright © 2019 Marc Jacques. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    convenience init(title: String, bodyText: String, context: NSManagedObjectContext) {
    
    self.init(context: context)
    
    
    self.title = title
    self.bodyText = bodyText
    self.timeStamp = Date()
    self.identifier = identifier
    }
}
