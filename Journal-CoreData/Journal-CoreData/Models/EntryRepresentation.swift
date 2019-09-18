//
//  EntryRepresentation.swift
//  Journal-CoreData
//
//  Created by Ciara Beitel on 9/18/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var bodyText: String
    var identifier: UUID
    var mood: String
    var timestamp: Date
    var title: String
}
