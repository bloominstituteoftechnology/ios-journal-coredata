//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Bradley Diroff on 3/25/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var identifier: String
    var title: String
    var bodyText: String?
    var timeStamp: String
    var mood: String
}
