//
//  JournalController.swift
//  Journal
//
//  Created by Alex Rhodes on 9/16/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import Foundation
import CoreData

class JournalController {
    
    
    @discardableResult func createJournal(with title: String, bodyText: String, identifier: String?, time: Date) -> Journal {
    
        let entry = Journal(title: title, bodyText: bodyText, identifier: identifier ?? "", time: time, context: CoreDataStack.shared.mainContext)
        
        CoreDataStack.shared.saveToPersistentStore()
        
        return entry
    
    }
    
    func updateTask(journal: Journal, with title: String, bodyText: String?, identifier: String, time: Date) {
        
        journal.title = title
        journal.bodyText = bodyText
        journal.identifier = identifier
        
        
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    func delete(journal: Journal){
        
        CoreDataStack.shared.mainContext.delete(journal)
        CoreDataStack.shared.saveToPersistentStore()
        
    }
    
}
