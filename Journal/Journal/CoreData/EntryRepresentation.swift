//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Dennis Rudolph on 11/13/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String?
    var mood: String
    var identifier: String?
    var timestamp: Date
}
