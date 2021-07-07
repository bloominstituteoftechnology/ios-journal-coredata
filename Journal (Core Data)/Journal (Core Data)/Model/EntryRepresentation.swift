//
//  EntryRepresentation.swift
//  Journal (Core Data)
//
//  Created by David Wright on 2/18/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String?
    var bodyText: String?
    var timestamp: Date?
    var identifier: String?
    var mood: String
}
