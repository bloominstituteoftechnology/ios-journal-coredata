//
//  EntryRepresentation.swift
//  Journal Core Data
//
//  Created by Austin Cole on 1/16/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable, Equatable {
    var title: String
    var bodyText: String
    var timestamp: Date
    var mood: String
    var identifier: String
}

func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.identifier == rhs.identifier
    }
func != (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.identifier != rhs.identifier
}
