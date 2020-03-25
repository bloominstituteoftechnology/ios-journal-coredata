//
//  EntryRepresentation.swift
//  journal-coredata
//
//  Created by Karen Rodriguez on 3/25/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import Foundation

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
}
