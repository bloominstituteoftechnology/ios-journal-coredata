//
//  EntryRepresentation.swift
//  Journel
//
//  Created by Nathan Hedgeman on 8/23/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import Foundation
import CoreData

struct EntryRepresentation: Codable, Equatable {
    
    let title: String
    let identifier: UUID
    let bodyText: String
    let mood: String
    let timeStamp: Date
}

//Comparitive Methods
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
