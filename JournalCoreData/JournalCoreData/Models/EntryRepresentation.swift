//
//  EntryRepresentation.swift
//  JournalCoreData
//
//  Created by scott harris on 2/26/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    let title: String
    let bodyText: String
    let mood: String
    let timestamp: Date
    let identifier: String
    
}
