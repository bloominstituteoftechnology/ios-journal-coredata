//
//  NSManagedObjectContextExtension.swift
//  Journal
//
//  Created by brian vilchez on 10/15/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func saveChanges() {
        if hasChanges {
            do {
                try save()
            } catch let error as NSError {
                NSLog("error saving to persistent Store: \(error.localizedDescription)")
            }
        }
    }
}
