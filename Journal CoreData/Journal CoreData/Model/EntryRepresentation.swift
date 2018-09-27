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


// MARK: - Equatable stubs

func ==(lhs: EntryRespresentation, rhs: Entry) -> Bool {
    return rhs.title == lhs.title &&
        rhs.bodyText == lhs.bodyText &&
        rhs.mood == lhs.mood &&
        rhs.timestamp == lhs.timestamp &&
        rhs.identifier == lhs.identifier
}

func ==(lhs: Entry, rhs: EntryRespresentation) -> Bool {
    return rhs == lhs
}

func !=(lhs: EntryRespresentation, rhs: Entry) -> Bool {
    return !(rhs == lhs)
}

func !=(lhs: Entry, rhs: EntryRespresentation) -> Bool {
    return rhs != lhs
}


