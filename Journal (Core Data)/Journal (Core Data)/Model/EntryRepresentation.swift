//
//  EntryRepresentation.swift
//  Journal (Core Data)
//
//  Created by Simon Elhoej Steinmejer on 15/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable, Equatable
{
    var title: String
    var bodyText: String
    var identifier: String
    var mood: String
    var timestamp: Date
}

func ==(lhs: Entry, rhs: EntryRepresentation) -> Bool
{
    return lhs.bodyText == rhs.bodyText && lhs.title == rhs.title && lhs.identifier == rhs.identifier && lhs.mood == rhs.mood && lhs.timestamp == rhs.timestamp
}

func ==(lhs: EntryRepresentation, rhs: EntryRepresentation) -> Bool
{
    return lhs.bodyText == rhs.bodyText && lhs.title == rhs.title && lhs.identifier == rhs.identifier && lhs.mood == rhs.mood && lhs.timestamp == rhs.timestamp
}

func !=(lhs: EntryRepresentation, rhs: EntryRepresentation) -> Bool
{
    return lhs.bodyText != rhs.bodyText && lhs.title != rhs.title && lhs.identifier != rhs.identifier && lhs.mood != rhs.mood && lhs.timestamp != rhs.timestamp
}

func !=(lhs: Entry, rhs: EntryRepresentation) -> Bool
{
    return lhs.bodyText != rhs.bodyText && lhs.title != rhs.title && lhs.identifier != rhs.identifier && lhs.mood != rhs.mood && lhs.timestamp != rhs.timestamp
}

