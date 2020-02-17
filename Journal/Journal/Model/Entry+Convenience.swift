//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Eoin Lavery on 13/02/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import UIKit
import CoreData

extension Entry {
    
    @discardableResult
    convenience init(name: String, notes: String? = "", date: Date = Date(), mood: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.notes = notes
        self.date = date
        self.mood = mood
    }
    
}
