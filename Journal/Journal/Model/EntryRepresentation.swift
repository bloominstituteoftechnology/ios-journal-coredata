//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Brian Rouse on 5/20/20.
//  Copyright © 2020 Brian Rouse. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var identifier: String
    var title: String
    var bodyText: String
    var timestamp: Date
    var mood: String
}
