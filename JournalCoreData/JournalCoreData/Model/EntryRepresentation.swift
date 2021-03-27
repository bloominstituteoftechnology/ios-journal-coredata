//
//  EntryRepresentation.swift
//  JournalCoreData
//
//  Created by Enrique Gongora on 2/26/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String?
    var timestamp: Date?
    var identifier: String?
    var bodyText: String?
    var mood: String
}
