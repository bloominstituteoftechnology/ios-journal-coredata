//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Chad Rutherford on 12/18/19.
//  Copyright © 2019 Chad Rutherford. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String?
    var timestamp: Date
    var identifier: String
    var mood: String
}
