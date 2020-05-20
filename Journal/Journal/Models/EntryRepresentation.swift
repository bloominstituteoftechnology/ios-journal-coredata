//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Dahna on 5/20/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var identifier: String
    var title: String
    var bodyText: String
    var timeStamp: Date
    var mood: String
}
