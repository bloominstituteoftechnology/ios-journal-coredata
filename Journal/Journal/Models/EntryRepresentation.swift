//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Michael Stoffer on 7/16/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation

struct EntryRepresentation: Equatable, Codable {
    var title: String
    var bodyText: String?
    var mood: String?
    var timestamp: Date
    var identifier: String
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.identifier == rhs.identifier && lhs.title == rhs.title && lhs.bodyText == rhs.bodyText && lhs.mood == rhs.mood && lhs.timestamp == rhs.timestamp
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
