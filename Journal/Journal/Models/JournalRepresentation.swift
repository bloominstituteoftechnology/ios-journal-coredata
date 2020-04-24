//
//  JournalRepresentation.swift
//  Journal
//
//  Created by Chris Dobek on 4/22/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation

struct JournalRepresentation: Codable {
    var identifier: String
    var title: String
    var bodyText: String?
    var mood: String
    var timestamp: Date
}
