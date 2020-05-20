//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Nonye on 5/20/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    
    var title: String
    var bodyText: String
    var mood: String
    var identifier: String?
    var timeStamp: Date

}
