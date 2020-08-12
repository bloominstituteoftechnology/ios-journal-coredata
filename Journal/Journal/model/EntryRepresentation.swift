//
//  EntryRepresentation.swift
//  Journal
//
//  Created by ronald huston jr on 8/11/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var id: String
    var mood: String
    var bodyText: String
    var title: String
    var timestamp: Date
}
