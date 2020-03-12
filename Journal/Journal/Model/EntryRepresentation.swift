//
//  EntryRepresentation.swift
//  Journal
//
//  Created by denis cedeno on 12/10/19.
//  Copyright © 2019 DenCedeno Co. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String?
    var bodyText: String?
    var mood: String
    var timeStamp: Date?
    var identifier: String?
}
