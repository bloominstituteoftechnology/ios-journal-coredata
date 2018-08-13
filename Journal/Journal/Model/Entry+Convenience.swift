//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jeremy Taylor on 8/13/18.
//  Copyright © 2018 Bytes-Random L.L.C. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = UUID().uuidString) {
        self.init(context: CoreDataStack.shared.mainContext)
        
        self.title = title
        self.bodyText = bodyText
        
    }
}
