//
//  EntryRepresentation.swift
//  Journal CoreData
//
//  Created by Ilgar Ilyasov on 9/26/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

struct EntryRespresentation: Decodable, Equatable {
    
    var title: String
    var bodyText: String?
    var mood: String
    var timestamp: Date
    var identifier: String
}

func ==(lhs: EntryRespresentation, rhs: Entry) -> Bool {
    return lhs.title == rhs.title &&
        lhs.bodyText == rhs.bodyText &&
        lhs.mood == rhs.mood &&
        lhs.timestamp == rhs.timestamp &&
        lhs.identifier == rhs.identifier
    
}

func ==(lhs: Entry, rhs: EntryRespresentation) -> Bool {
    return lhs.title == rhs.title &&
        lhs.bodyText == rhs.bodyText &&
        lhs.mood == rhs.mood &&
        lhs.timestamp == rhs.timestamp &&
        lhs.identifier == rhs.identifier
}

func !=(lhs: EntryRespresentation, rhs: Entry) -> Bool {
    return lhs.title != rhs.title &&
        lhs.bodyText != rhs.bodyText &&
        lhs.mood != rhs.mood &&
        lhs.timestamp != rhs.timestamp &&
        lhs.identifier != rhs.identifier
}

func !=(lhs: Entry, rhs: EntryRespresentation) -> Bool {
    return lhs.title != rhs.title &&
        lhs.bodyText != rhs.bodyText &&
        lhs.mood != rhs.mood &&
        lhs.timestamp != rhs.timestamp &&
        lhs.identifier != rhs.identifier
}


