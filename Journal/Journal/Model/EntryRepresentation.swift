//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Paul Yi on 2/20/19.
//  Copyright © 2019 Paul Yi. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable, Equatable {
    var title: String?
    var bodyText: String?
    var timestamp: Date?
    var identifier: String?
    var mood: String?
}

func ==(lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.title == rhs.title &&
    lhs.bodyText == rhs.bodyText &&
    lhs.timestamp == rhs.timestamp &&
    lhs.identifier == rhs.identifier &&
    lhs.mood == rhs.mood
}

func ==(lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs == lhs
}

func !=(lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return !(rhs == lhs)
}

func !=(lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs != lhs
}
