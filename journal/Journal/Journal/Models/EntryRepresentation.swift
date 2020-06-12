//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Ian French on 6/11/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import Foundation


struct EntryRepresentation: Codable {
    var identifier: String
    var title: String
    var bodyText: String
    var timestamp: Date
    var mood: String
}
