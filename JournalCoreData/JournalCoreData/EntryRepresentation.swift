//
//  EntryRepresentation.swift
//  JournalCoreData
//
//  Created by Angel Buenrostro on 2/13/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable, Equatable {
    
    let bodyText: String
    let identifier: String
    let mood: String
    let timestamp: Date
    let title: String
    
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return
        lhs.identifier == rhs.identifier &&
        lhs.bodyText == rhs.bodyText &&
        lhs.mood == rhs.mood &&
        lhs.timestamp == rhs.timestamp &&
        lhs.title == rhs.title
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
