//
//  EntryController.swift
//  Journal
//
//  Created by Bradley Diroff on 3/23/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    func saveToPersistentStore(title: String, bodyText = String) {
        Entry(title: title, bodyText: bodyText, timeStamp: Date(), identifier: "\(UUID)")
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
}
