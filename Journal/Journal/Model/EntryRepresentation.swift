//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Jake Connerly on 8/21/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation


struct EntryRepresentation: Codable {
    
    let title: String?
    let timeStamp: Date?
    let mood: String?
    let identifier: String?
    let bodyText: String?
}

func ==(lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.title == rhs.title &&
        lhs.timeStamp == rhs.timeStamp &&
        lhs.mood == rhs.mood &&
        lhs.identifier == rhs.identifier &&
        lhs.bodyText == rhs.bodyText
}

func ==(lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs == lhs
}

func !=(lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return !(rhs == lhs)
}

func !=(lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs != lhs
}
