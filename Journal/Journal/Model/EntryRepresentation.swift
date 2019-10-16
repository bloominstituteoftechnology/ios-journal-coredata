//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Isaac Lyons on 10/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    let bodyText: String
    let identifier: String
    let mood: String
    let timestamp: Date
    let title: String
}
