//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Jorge Alvarez on 1/29/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    
    var title: String
    var bodyText: String
    var mood: String?
    var timestamp: Date
    var identifier: String?
}
