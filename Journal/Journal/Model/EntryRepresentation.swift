//
//  TaskRepresentation.swift
//  Journal
//
//  Created by Clayton Watkins on 6/10/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var timestamp: Date
    var mood: String
    var identifier: String
    var bodyText: String
}
