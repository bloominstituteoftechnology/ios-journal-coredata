//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Wyatt Harrell on 3/25/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var bodyText: String
    var identifier: String
    var mood: String
    var timestamp: Date
    var title: String
}
