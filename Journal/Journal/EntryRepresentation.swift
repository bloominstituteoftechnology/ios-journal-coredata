//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Mark Gerrior on 3/25/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    
    /// match exactly or else the JSON from Firebase will not decode into this struct properly
    var identifier: String
    var title: String
    var bodyText: String?
    var timestamp: Date?
    var mood: String
    
}
