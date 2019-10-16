//
//  EntryRepresentation.swift
//  JournalCoreData
//
//  Created by Gi Pyo Kim on 10/16/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    let title: String
    let mood: String
    let bodyText: String
    let timestamp: Date
    let identifier: String
}
