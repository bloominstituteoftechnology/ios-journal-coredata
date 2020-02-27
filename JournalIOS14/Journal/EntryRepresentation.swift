//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Ufuk Türközü on 26.02.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String?
    var mood: String
    var timestamp: Date
    var id: String
}
