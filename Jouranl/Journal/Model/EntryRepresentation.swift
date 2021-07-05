//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Joshua Rutkowski on 2/18/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var identifier: String?
    var title: String
    var timestamp: Date
    var bodyText: String
    var mood: String
}
