//
//  EntryRep.swift
//  CoreJournal
//
//  Created by Aaron Cleveland on 1/30/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation

struct EntryRep: Codable {
    var identifier: String?
    var title: String
    var timestamp: Date?
    var bodyText: String
    var mood: String
}
