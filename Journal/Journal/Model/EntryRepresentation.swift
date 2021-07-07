//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Bradley Yin on 8/21/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable {
    var mood: Int64?
    var bodyText: String?
    var identifier: UUID?
    var title: String?
    var timeStamp: Date?
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    //guard let identifier1 = lhs.identifier, let identifier2 = rhs.identifier else { return false }
    return  lhs.identifier == rhs.identifier && lhs.title == rhs.title && lhs.mood == rhs.mood && rhs.bodyText == lhs.bodyText && rhs.timeStamp == lhs.timeStamp
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

