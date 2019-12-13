//
//  EntryRepresentation.swift
//  JournalPT3
//
//  Created by Jessie Ann Griffin on 12/10/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

struct EntryRepresentation: Codable {
    var title: String
    var timestamp: Date
    var mood: String
    var identifier: String?
    var bodyText: String?
}
