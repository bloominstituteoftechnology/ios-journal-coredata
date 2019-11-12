//
//  EntryRepresentation.swift
//  Journal
//
//  Created by morse on 11/12/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    let title: String
    let mood: String
    let bodyText: String?
    let identifier: String
    let timestamp: Date
}
