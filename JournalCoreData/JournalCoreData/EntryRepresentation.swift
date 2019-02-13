//
//  EntryRepresentation.swift
//  JournalCoreData
//
//  Created by Nelson Gonzalez on 2/13/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
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
    
    return lhs.identifier == rhs.identifier && lhs.title == rhs.title && lhs.bodyText == rhs.bodyText && lhs.timestamp == rhs.timestamp && lhs.mood == rhs.mood
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
    
