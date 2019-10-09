//
//  JournalEntryRepresentation.swift
//  Journal
//
//  Created by Joel Groomer on 10/8/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import Foundation

struct JournalEntryRepresentation: Codable {
    var bodyText: String?
    var identifier: String?
    var mood: String
    var timestamp: Date
    var title: String
}
