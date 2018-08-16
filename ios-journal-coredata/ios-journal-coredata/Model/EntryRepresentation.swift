//
//  EntryRepresentation.swift
//  ios-journal-coredata
//
//  Created by De MicheliStefano on 15.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable, Equatable {
    
    var title: String
    var bodyText: String
    var mood: String
    var timestamp: Date
    var identifier: String
    
}

func ==(lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return
        lhs.title == rhs.title &&
        lhs.bodyText == rhs.bodyText &&
        lhs.mood == rhs.mood &&
        lhs.timestamp == rhs.timestamp &&
        lhs.identifier == lhs.identifier
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
