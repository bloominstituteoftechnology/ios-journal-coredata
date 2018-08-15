//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Samantha Gatt on 8/15/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable, Equatable {
    var title: String
    var body: String
    var mood: String
    var timestamp: Date
    var identifier: String
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return
        lhs.title == rhs.title &&
        lhs.body == rhs.body &&
        lhs.mood == rhs.mood &&
        lhs.timestamp == rhs.timestamp &&
        lhs.identifier == rhs.identifier
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
