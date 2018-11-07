//
//  EntryStub.swift
//  Journal-CoreData
//
//  Created by Nikita Thomas on 11/7/18.
//  Copyright © 2018 Nikita Thomas. All rights reserved.
//

import Foundation

struct EntryStub: Decodable, Equatable {
    var title: String
    var timeStamp: Date
    var mood: String
    var identifier: String
    var bodyText: String
}

func == (lhs: EntryStub, rhs: Entry) -> Bool {
    return
        lhs.title == rhs.title &&
        lhs.timeStamp == rhs.timeStamp &&
        lhs.mood == rhs.mood &&
        lhs.identifier == rhs.identifier &&
        lhs.bodyText == rhs.bodyText
}

func == (lhs: Entry, rhs: EntryStub) -> Bool {
    return
        lhs.title == rhs.title &&
            lhs.timeStamp == rhs.timeStamp &&
            lhs.mood == rhs.mood &&
            lhs.identifier == rhs.identifier &&
            lhs.bodyText == rhs.bodyText
}

func != (lhs: EntryStub, rhs: Entry) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: Entry, rhs: EntryStub) -> Bool {
    return !(rhs == lhs)
}





