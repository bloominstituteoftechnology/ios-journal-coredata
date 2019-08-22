//
//  EntryRepresentation.swift
//  journal-coredata
//
//  Created by Alex Shillingford on 8/21/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable {
    var title: String?
    var bodyText: String?
    var timestamp: Date?
    var identifier: UUID?
    var mood: String?
}

func ==(lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.identifier == rhs.identifier
}

func ==(lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return lhs.identifier == rhs.identifier
}

func !=(lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return !(lhs == rhs)
}

func !=(lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return lhs != rhs
}
