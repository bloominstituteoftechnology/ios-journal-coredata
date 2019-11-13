//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Lambda_School_Loaner_204 on 11/13/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String?
    var timestamp: Date
    var mood: String
    var identifier: String?
}
