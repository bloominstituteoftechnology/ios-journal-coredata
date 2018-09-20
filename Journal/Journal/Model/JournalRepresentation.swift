//
//  JournalRepresentation.swift
//  Journal
//
//  Created by Farhan on 9/19/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation

struct JournalRepresentation: Decodable, Equatable {
    
    var title: String
    var notes: String?
    var mood: String
    var timestamp: Date
    var identifier: String
    
    init(title: String, notes: String?, timestamp: Date, mood: String, identifier: String) {
        self.title = title
        self.notes = notes
        self.timestamp = timestamp
        self.mood = mood
        self.identifier = identifier
    }
    
}

func == (lhs: JournalRepresentation, rhs: Journal) -> Bool {
    if lhs.title == rhs.title
    && lhs.notes == rhs.notes
    && lhs.mood == rhs.mood
    && lhs.timestamp == rhs.timestamp
        && lhs.identifier == rhs.identifier {
        return true
    } else {
        return false
    }
}

func == (lhs: Journal, rhs: JournalRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: Journal, rhs: JournalRepresentation) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: JournalRepresentation, rhs: Journal) -> Bool {
    return rhs != lhs
}
