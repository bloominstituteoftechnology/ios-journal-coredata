//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Sean Acres on 7/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String?
    var bodyText: String?
    var mood: String?
    var timestamp: Date?
    var identifier: String?
}

extension EntryRepresentation: Equatable {
    static func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
        return
            lhs.timestamp == rhs.timestamp &&
            lhs.identifier == rhs.identifier?.uuidString
    }
    
    static func == (lhs: Entry, rhs: EntryRepresentation) -> Bool {
        return rhs == lhs
    }
    
    static func != (lhs: Entry, rhs: EntryRepresentation) -> Bool {
        return rhs != lhs
    }
    
    static func != (lhs: EntryRepresentation, rhs: Entry) -> Bool {
        return !(rhs == lhs)
    }
}
