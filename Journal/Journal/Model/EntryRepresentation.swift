//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Kat Milton on 7/24/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable {
    var title: String?
    var bodyText: String?
    var timeStamp: Date?
    var identifier: String?
    var month: String?
    var year: String?
//    var mood: String?
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.identifier == rhs.identifier && lhs.timeStamp == rhs.timeStamp
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
