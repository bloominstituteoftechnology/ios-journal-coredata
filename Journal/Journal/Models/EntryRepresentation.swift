//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Matthew Martindale on 4/28/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String?
    var timestamp: Date
    var identifier: String
    var mood: String
}
