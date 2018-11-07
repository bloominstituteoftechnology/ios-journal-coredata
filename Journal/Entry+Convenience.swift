//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Lotanna Igwe-Odunze on 11/7/18.
//  Copyright © 2018 Lotanna. All rights reserved.
//

import Foundation
import CoreData

extension Entry { //This should be extending the Entity in the data model.
    
    convenience init(
        title: String,
        notes: String? = nil,
        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.notes = notes
    }
}
