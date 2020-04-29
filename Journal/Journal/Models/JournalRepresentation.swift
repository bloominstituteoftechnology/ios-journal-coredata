//
//  JournalRepresentation.swift
//  Journal
//
//  Created by David Williams on 4/28/20.
//  Copyright © 2020 david williams. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {

    var identifier: String
    var title: String
    var bodyText: String
    var timestamp: Date
    var mood: String
}
