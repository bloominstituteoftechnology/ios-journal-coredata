//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Kenny on 1/29/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    let bodyText: String
    let identifier: String
    let mood: String?
    let timestamp: Date
    let title: String
}
