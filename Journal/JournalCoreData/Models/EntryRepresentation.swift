//
//  EntryRepresentation.swift
//  JournalCoreData
//
//  Created by Zack Larsen on 12/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String?
    var bodyText: String?
    var timestamp: Date? 
    var mood: String?
    var identifier: String?
}
