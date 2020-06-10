//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Kenneth Jones on 6/9/20.
//  Copyright © 2020 Kenneth Jones. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var identifier: String
    var title: String
    var bodyText: String?
    var mood: String
    var timestamp: Date
}
