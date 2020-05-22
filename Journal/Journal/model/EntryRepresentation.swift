//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Vincent Hoang on 5/20/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var identifier: String
    var title: String
    var bodyText: String
    var mood: String
    var timeStamp: Date
}
