//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Thomas Sabino-Benowitz on 11/13/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    
    var bodyText: String?
    var identifier: String?
    var mood: String
    var timestamp: Date
    var title: String
    
}
