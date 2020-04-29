//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Claudia Contreras on 4/28/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var identifier: String
    var title: String
    var bodyText: String
    var timestamp: Date
    var mood: String
}
