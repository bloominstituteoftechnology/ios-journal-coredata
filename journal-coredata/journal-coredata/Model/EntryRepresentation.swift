//
//  EntryRepresentation.swift
//  journal-coredata
//
//  Created by Rob Vance on 6/9/20.
//  Copyright © 2020 Robs Creations. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var identifier: String
    var title: String
    var bodyText: String?
    var timestamp: Date
    var mood: String
}
