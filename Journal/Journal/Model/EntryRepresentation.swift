//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Jessie Ann Griffin on 10/8/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    
    var title: String
    var bodyText: String?
    var timeStamp: Date
    var mood: String
    var identifier: String?

}
