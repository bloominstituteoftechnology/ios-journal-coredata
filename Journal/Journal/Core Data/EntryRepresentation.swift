//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Mitchell Budge on 6/5/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable {
    
    var title: String?
    var bodyText: String?
    var timestamp: Date?
    var mood: String?
    var identifier: String?

}

func ==(lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return
        lhs.title == rhs.title &&
            lhs.bodyText == rhs.bodyText &&
            lhs.timestamp == rhs.timestamp &&
            lhs.mood == rhs.mood &&
            lhs.identifier == rhs.identifier
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
