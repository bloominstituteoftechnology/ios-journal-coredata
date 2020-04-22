//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Mark Poggi on 4/22/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var identifier: String
    var title: String
    var bodyText: String?
    var mood: String 
    var timestamp: Date
}
