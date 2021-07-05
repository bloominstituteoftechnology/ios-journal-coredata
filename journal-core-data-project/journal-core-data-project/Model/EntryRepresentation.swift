//
//  EntryRepresentation.swift
//  journal-core-data-project
//
//  Created by Vuk Radosavljevic on 8/15/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import Foundation


struct EntryRepresentation: Decodable, Equatable {
    
    var title: String
    var bodyText: String
    var timestamp: Date
    var mood: String
    var identifier: String
    
}

func ==(lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.bodyText == rhs.bodyText &&
    lhs.title == rhs.title &&
    lhs.timestamp == rhs.timestamp &&
    lhs.mood == rhs.mood &&
    lhs.identifier == rhs.identifier
}

func == (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return lhs == rhs
}

func !=(lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return !(rhs == lhs)
}

func !=(lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs != lhs
}




