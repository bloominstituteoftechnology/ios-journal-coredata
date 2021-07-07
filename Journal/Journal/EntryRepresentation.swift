//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Lambda_School_Loaner_218 on 12/18/19.
//  Copyright © 2019 Lambda_School_Loaner_218. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String?
    var timestamp: Date
    var identifier: String
    var mood: String
}
