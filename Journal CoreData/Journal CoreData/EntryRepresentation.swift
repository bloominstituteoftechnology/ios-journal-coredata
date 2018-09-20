//
//  EntryRepresentation.swift
//  Journal CoreData
//
//  Created by Moin Uddin on 9/19/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import Foundation

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    //print(rhs)
    //print(lhs)
    return lhs.identifier == rhs.identifier && lhs.title == rhs.title && lhs.bodyText == rhs.bodyText && rhs.timestamp == lhs.timestamp && rhs.mood == lhs.mood
}

func == (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs != lhs
}

func != (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return !(rhs == lhs)
}


struct EntryRepresentation: Decodable, Equatable {
    var title: String
    var bodyText: String
    var identifier: String
    var mood: String
    var timestamp: Date
}
