//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Cameron Collins on 4/23/20.
//  Copyright © 2020 Cameron Collins. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var identifier: String
    var bodyText: String
    var mood: String
    var timeStamp: String
    var title: String
}
