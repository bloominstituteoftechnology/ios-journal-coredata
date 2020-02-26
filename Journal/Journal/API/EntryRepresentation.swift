//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Chris Gonzales on 2/26/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation

struct EntryRepresenation: Codable {
    let identifier: String
    let title: String
    let bodyText: String
    let mood: String
    let timestamp: Date
}
