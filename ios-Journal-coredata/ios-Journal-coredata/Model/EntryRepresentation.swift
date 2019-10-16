//
//  EntryRepresentation.swift
//  ios-Journal-coredata
//
//  Created by Jonalynn Masters on 10/16/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    let title: String
    let bodyText: String
    let timestamp: Date
    let identifier: UUID
    let mood: String
}

// Add a property in this struct for each attribute in the Entry model. Their names should match exactly or else the JSON from Firebase will not decode into this struct properly.

