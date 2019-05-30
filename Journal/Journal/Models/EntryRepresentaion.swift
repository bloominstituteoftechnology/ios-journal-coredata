//
//  EntryRepresentaion.swift
//  Journal
//
//  Created by Christopher Aronson on 5/29/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable {
    let title: String
    let bodyText: String
    let mood: String
    let timestamp: Date
    let identifier: String
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.title == rhs.title &&
        lhs.bodyText == rhs.bodyText &&
        lhs.mood == rhs.mood &&
        lhs.timestamp == rhs.timestamp! &&
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
