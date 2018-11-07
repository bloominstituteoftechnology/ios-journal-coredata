//
//  Entries.swift
//  Journal
//
//  Created by Lotanna Igwe-Odunze on 11/7/18.
//  Copyright © 2018 Lotanna. All rights reserved.
//

import Foundation
import CoreData

//Global
var entries: [Entry] {
    let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
    let moc = CoreDataStack.shared.mainContext
    do { return try moc.fetch(fetchRequest) }
    catch { NSLog("Error fetching task: \(error)")
        return [] }
}
