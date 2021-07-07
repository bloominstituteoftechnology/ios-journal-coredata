//
//  EntryRepresentation.swift
//  Journal: Core Data
//
//  Created by Ivan Caldwell on 1/24/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable, Equatable {
    var title: String?
    var bodyText: String?
    var timestamp: Date?
    var mood: String?
    var identifier: String?
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.identifier == rhs.identifier && lhs.title == rhs.title && lhs.bodyText == rhs.bodyText && lhs.mood == rhs.mood
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
