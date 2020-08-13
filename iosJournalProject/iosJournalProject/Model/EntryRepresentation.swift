//
//  EntryRepresentation.swift
//  iosJournalProject
//
//  Created by BrysonSaclausa on 8/11/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var identifier: String
    var title: String
    var timestamp = Date()
    var bodyText: String
    var mood: String
}

