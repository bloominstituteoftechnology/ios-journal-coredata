//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Juan M Mariscal on 4/28/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var identifier: String
    var title: String
    var bodyText: String?
    var timeStamp: Date
    var mood: Mood
}
