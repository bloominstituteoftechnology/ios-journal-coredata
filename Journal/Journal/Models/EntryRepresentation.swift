//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Jon Bash on 2019-11-13.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String
    var mood: String
    var timestamp: Date
    var identifier: String
}
