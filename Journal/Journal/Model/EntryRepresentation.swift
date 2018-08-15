//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Jeremy Taylor on 8/15/18.
//  Copyright © 2018 Bytes-Random L.L.C. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable, Equatable {
    var title: String
    var timestamp: Date
    var mood: String
    var identifier: String
    var bodyText: String
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.title == rhs.title &&
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
