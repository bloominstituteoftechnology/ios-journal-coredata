//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Scott Bennett on 9/26/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import Foundation

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.title == rhs.title &&
        lhs.bodyText == rhs.bodyText &&
        lhs.mood == rhs.mood &&
        lhs.timestamp == rhs.timestamp &&
        lhs.identifier == rhs.identifier
}

func == (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: EntryRepresentation, rhs: Entry) -> Bool{
    return !(rhs == lhs)
}

func != (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs != lhs
}

struct EntryRepresentation: Decodable, Equatable {
    
    var title: String
    var bodyText: String?
    var mood: String
    var timestamp: Date
    var identifier: String
    
    init(title: String, bodyText: String, mood: String, timestamp: Date, identifier: String) {
        self.title = title
        self.bodyText = bodyText
        self.mood = mood
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
