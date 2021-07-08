//
//  EntryRepresentation.swift
//  Journal CoreData
//
//  Created by Ngozi Ojukwu on 8/22/18.
//  Copyright © 2018 iyin. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable, Equatable {
    var name: String
    var timestamp: Date
    var mood: String
    var identifier: String
    var bodyText: String
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.name == rhs.name &&
        lhs.timestamp == rhs.timestamp &&
        lhs.mood == rhs.mood &&
        lhs.identifier == rhs.identifier &&
        lhs.bodyText == rhs.bodyText
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
