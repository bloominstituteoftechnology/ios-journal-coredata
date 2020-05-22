//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Stephanie Ballard on 5/20/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var bodyText: String
    var identifier: String
    var mood: String
    var timestamp: Date
    var title: String
}
