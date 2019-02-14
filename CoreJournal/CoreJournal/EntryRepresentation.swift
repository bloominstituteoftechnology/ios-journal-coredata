//
//  EntryRepresentation.swift
//  CoreJournal
//
//  Created by Jocelyn Stuart on 2/13/19.
//  Copyright © 2019 JS. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable, Equatable {
    
    var title: String
    var bodyText: String
    var identifier: String
    var timestamp: Date
    var mood: String
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.title == rhs.title && rhs.identifier?.uuidString == lhs.identifier && rhs.bodyText == lhs.bodyText && rhs.timestamp == lhs.timestamp && rhs.mood == lhs.mood
}

func == (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs == lhs
}
func != (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs != lhs
}

