//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Enzo Jimenez-Soto on 5/20/20.
//  Copyright © 2020 Enzo Jimenez-Soto. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String
    var mood: String
    var timestamp: Date
    var identifier: String?
}
