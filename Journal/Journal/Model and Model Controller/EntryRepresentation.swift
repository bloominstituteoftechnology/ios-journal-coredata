//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Andrew Liao on 8/15/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable, Equatable {
    let title: String
    let bodyText: String
    let mood: String
    let identifier:String
    let timeStamp: Date
}

func ==(lhs:EntryRepresentation, rhs:Entry) -> Bool{
    return lhs.title == rhs.title &&
        lhs.bodyText == rhs.bodyText &&
        lhs.mood == rhs.mood &&
        lhs.identifier == rhs.identifier &&
        lhs.timeStamp == rhs.timeStamp
}

func ==(lhs:Entry, rhs:EntryRepresentation) -> Bool{
    return rhs == lhs
}

func !=(lhs:EntryRepresentation, rhs:Entry) -> Bool{
    return !(rhs == lhs)
}

func !=(lhs:Entry, rhs:EntryRepresentation) -> Bool{
    return rhs != lhs
}
