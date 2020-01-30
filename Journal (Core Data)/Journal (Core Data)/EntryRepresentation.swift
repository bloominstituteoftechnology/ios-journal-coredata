//
//  EntryRepresentation.swift
//  Journal (Core Data)
//
//  Created by Michael on 1/29/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String
    var timestamp: Date?
    var identifier: String?
    var mood: String
}
