//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Hayden Hastings on 6/5/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import Foundation
import CoreData

struct EntryRepresentation: Codable {
    
    var title: String
    var bodyText: String
    var timestamp: Date
    var identifier: String
    var mood: String
    
}

extension EntryRepresentation: Equatable {
    static func ==(lhs: EntryRepresentation, rhs: Entry) -> Bool {
        return lhs.title == rhs.title &&
        lhs.bodyText == rhs.bodyText &&
        lhs.timestamp == rhs.timestamp &&
        lhs.identifier == rhs.identifier &&
        lhs.mood == rhs.mood
    }
    
    static func ==(lhs: Entry, rhs: EntryRepresentation) -> Bool {
        return rhs == lhs
    }
    
    static func !=(lhs: EntryRepresentation, rhs: Entry) -> Bool {
        return !(rhs == lhs)
    }
    
    static func !=(lhs: Entry, rhs: EntryRepresentation) -> Bool {
        return rhs != lhs
    }
}
