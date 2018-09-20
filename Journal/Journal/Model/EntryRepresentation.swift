//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Daniela Parra on 9/19/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable, Equatable {
    let title: String
    let bodyText: String
    let timestamp: Date
    let identifier: String
    let mood: String
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return
        lhs.title == rhs.title &&
        lhs.bodyText == rhs.bodyText &&
        lhs.timestamp == rhs.timestamp &&
        lhs.identifier == rhs.identifier &&
        lhs.mood == rhs.mood
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

