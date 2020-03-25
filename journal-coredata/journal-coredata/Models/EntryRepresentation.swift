//
//  EntryRepresentation.swift
//  journal-coredata
//
//  Created by Karen Rodriguez on 3/25/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import Foundation
import CoreData

struct EntryRepresentation: Codable {
    var identifier: String
    var title: String
    var bodyText: String?
    var timestamp: Date
    var mood: String
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation) {
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText ?? ""
        entry.mood = entryRepresentation.mood
        entry.timestamp = entryRepresentation.timestamp
    }
    
    func updateEntries(with representations: [EntryRepresentation]) {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        // making sure every representation we're messing with has an identifier
        let representationByIds = representations.filter { $0.identifier != nil}
        // creating a brand new array that only consists of the identifiers from the previous thingies
        let representationsIdentifiers = representationByIds.map { $0.identifier }
        
        let dic = Dictionary(uniqueKeysWithValues: zip(<#T##sequence1: Sequence##Sequence#>, <#T##sequence2: Sequence##Sequence#>))
        
        
    }
}
