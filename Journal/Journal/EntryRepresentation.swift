//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Blake Andrew Price on 12/11/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String?
    var timestamp: Date
    var mood: String
    var identifier: String?
}
