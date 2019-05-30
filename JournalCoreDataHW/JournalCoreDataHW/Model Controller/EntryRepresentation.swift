//
//  EntryRepresentation.swift
//  JournalCoreDataHW
//
//  Created by Michael Flowers on 5/29/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable {
    var title: String
    var bodyText: String
    var timestamp: Date
    var identifier: String
    var mood: String
}

//this is because we are comparing two UNLIKE types to each other.
func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.title == rhs.title && lhs.bodyText == rhs.bodyText && lhs.mood == rhs.mood && lhs.timestamp == rhs.timestamp && lhs.identifier == rhs.identifier
}

func == (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return lhs == rhs
}

func != (lhs: EntryRepresentation, rhs: Entry) -> Bool {
        return !(rhs == lhs)
}

func != (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs != lhs
}





