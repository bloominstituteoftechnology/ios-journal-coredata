//
//  EntryController.swift
//  Journal
//
//  Created by Joel Groomer on 10/2/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import Foundation

class EntryController {
    
    var entries: [JournalEntry] {
        return self.loadFromPersistentStore()
    }
    
    func saveToPersistentStore() {
        
    }
    
    func loadFromPersistentStore() -> [JournalEntry] {
        
    }
    
    func createEntry(title: String, body: String) {
        
    }
    
    func updateEntry(entry: JournalEntry, newTitle: String, newBody: String) {
        
    }
    
    func deleteEntry(entry: JournalEntry) {
        
    }
}
