//
//  EntryRepresentation.swift
//  JournalCoreDataHW
//
//  Created by Michael Flowers on 5/29/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    let title: String
    let bodyText: String
    let timestamp: Date
    let identifier: String
    let mood: String
}
