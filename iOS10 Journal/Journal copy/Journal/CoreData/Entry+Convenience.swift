//
//  Entry+Convenience.swift
//  Journal
//
//  Created by brian vilchez on 10/15/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    convenience init(title:String, bodyText: String, identifier: String = "", timeStamp: Date = Date(), context:NSManagedObjectContext ) {
        self.init(context: context)
        
        self.title = title
        self.identifier = identifier
        self.timeStamp = timeStamp
    }
}
