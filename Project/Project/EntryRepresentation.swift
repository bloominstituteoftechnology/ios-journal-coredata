//
//  EntryRepresentation.swift
//  Project
//
//  Created by Ryan Murphy on 6/5/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import Foundation


struct EntryRepresentation: Codable {
    var bodyText: String
    var identifier: UUID
    var mood: String
    var timestamp: Date
    var title: String
    
    
    
}

func ==(lhs: EntryRepresentation, rhs: Entry ) -> Bool {
return rhs == lhs
}

func ==(lhs: Entry, rhs: EntryRepresentation ) -> Bool {
    return rhs == lhs
}

func !=(lhs: EntryRepresentation, rhs: Entry ) -> Bool {
    return !(rhs == lhs)
}

func !=(lhs: Entry, rhs: EntryRepresentation ) -> Bool {
    return rhs != lhs
}
