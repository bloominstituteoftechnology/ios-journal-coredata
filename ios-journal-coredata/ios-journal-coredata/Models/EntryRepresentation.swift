//
//  EntryRepresentation.swift
//  ios-journal-coredata
//
//  Created by Conner on 8/15/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable, Equatable {
    var bodyText: String
    var identifier: String
    var mood: String
    var timestamp: Date
    var title: String
}

func == (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return (lhs.bodyText == rhs.bodyText) &&
           (lhs.identifier == rhs.identifier) &&
           (lhs.mood == rhs.mood) &&
           (lhs.timestamp == rhs.timestamp) &&
           (lhs.title == rhs.title)
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs == rhs
}

func != (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs != lhs
}
