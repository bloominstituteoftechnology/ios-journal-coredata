//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Breena Greek on 4/28/20.
//  Copyright © 2020 Breena Greek. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String
    var timeStamp: Date
    var identifier: String
    var mood: String
}
