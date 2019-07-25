//
//  EntryRepresentation.swift
//  Journal (CoreData)
//
//  Created by Nathan Hedgeman on 7/24/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable{
    
    var title: String?
    var bodyText: String?
    var timestamp: Date?
    var identifier: String
    var mood: String?
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.identifier == rhs.identifier && lhs.title == rhs.title && lhs.bodyText == rhs.bodyText && lhs.mood == rhs.mood && lhs.timestamp == rhs.timestamp
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
