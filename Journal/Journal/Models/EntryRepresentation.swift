//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Harmony Radley on 4/22/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    
    var title: String
    var bodyText: String?
    var timestamp: Date
    var identifier: String
    var mood: String
}
