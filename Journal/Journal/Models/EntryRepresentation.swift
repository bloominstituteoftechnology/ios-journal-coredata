//
//  EntryRepresentation.swift
//  Journal
//
//  Created by John Kouris on 10/2/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    let title: String
    let bodyText: String?
    let identifier: String
    let mood: String
    let timestamp: Date
}
