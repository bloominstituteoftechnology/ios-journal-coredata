//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Shawn Gee on 3/25/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    let title: String
    let bodyText: String?
    let moodString: String
    let timestamp: Date
    let identifier: String
}
