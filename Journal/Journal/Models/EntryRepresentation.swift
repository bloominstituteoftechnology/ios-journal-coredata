//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Enayatullah Naseri on 7/18/19.
//  Copyright © 2019 Enayatullah Naseri. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String?
    var mood: String?
    var timestamp: Date
    var identifier: String
}
