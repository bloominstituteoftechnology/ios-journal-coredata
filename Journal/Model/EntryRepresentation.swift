//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Chad Parker on 4/28/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    
    let bodyText: String
    let identifier: String
    let mood: String
    let timestamp: Date
    let title: String
}
