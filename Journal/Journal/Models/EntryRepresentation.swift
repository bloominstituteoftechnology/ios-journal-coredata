//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Tobi Kuyoro on 26/02/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String?
    var timeStamp: Date
    var mood: String
    var identifier: String
}
