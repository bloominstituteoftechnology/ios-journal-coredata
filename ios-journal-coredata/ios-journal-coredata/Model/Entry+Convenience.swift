//
//  Entry+Convenience.swift
//  ios-journal-coredata
//
//  Created by De MicheliStefano on 13.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    convenience init(title: String, bodyText: String, identifier: String = UUID().uuidString, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        
    }
    
}
