//
//  EntryRepresentation.swift
//  My Journal - Core Data
//
//  Created by Nick Nguyen on 2/26/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation

struct EntryRepresentation : Codable {
    var title: String?
    var bodyText: String?
    var mood: String?
    var identifier: String?
    var timestamp: Date
}
