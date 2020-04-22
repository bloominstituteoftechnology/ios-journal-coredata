//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Hunter Oppel on 4/22/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var identifier: String
    var title: String
    var bodyText: String?
    var timestamp: Date
    var mood: String
}
