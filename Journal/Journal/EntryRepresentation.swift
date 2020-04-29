//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Morgan Smith on 4/28/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var timestamp: Date
    var bodyText: String
    var identifier: String
    var mood: String
}
