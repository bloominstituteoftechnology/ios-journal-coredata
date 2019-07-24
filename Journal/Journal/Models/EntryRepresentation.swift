//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Sean Acres on 7/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable {
    var title: String?
    var bodyText: String?
    var mood: String?
    var timestamp: Date?
    var identifier: String?
}
