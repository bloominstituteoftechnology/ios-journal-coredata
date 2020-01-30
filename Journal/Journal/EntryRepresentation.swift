//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Ufuk Türközü on 29.01.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var bodyText: String
    var identifier: String
    var mood: String
    var timestamp: Date
    var title: String
}
