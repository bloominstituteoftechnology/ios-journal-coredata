//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Nathanael Youngren on 2/20/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable, Equatable {
    let name: String
    let bodyText: String
    let timestamp: Date
    let identifier: String
    let mood: String
}

func ==(lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.name == rhs.name && lhs.bodyText == rhs.bodyText && lhs.timestamp == rhs.timestamp && lhs.identifier == rhs.identifier && lhs.mood == rhs.mood
}

func ==(lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return lhs == rhs
}

func !=(lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return !(rhs == lhs)
}

func !=(lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs != lhs
}


