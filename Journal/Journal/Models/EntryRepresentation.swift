//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Vici Shaweddy on 10/8/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String
    var mood: String
    var timestamp: Date
    var identifier: String?
}
