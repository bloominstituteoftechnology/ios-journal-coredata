//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Craig Swanson on 12/10/19.
//  Copyright © 2019 Craig Swanson. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var bodyText: String?
    var identifier: String
    var mood: String?
    var timestamp: Date
    var title: String
}
