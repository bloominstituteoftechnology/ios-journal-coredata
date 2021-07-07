//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Sal Amer on 2/18/20.
//  Copyright © 2020 Sal Amer. All rights reserved.
//

import Foundation

//this layer is translation object between Json (firebase)  & coreData

struct EntryRepresentation: Codable {
    var title: String?
    var timestamp: Date?
    var mood: String
    var identifier: String? // should be string.. firebase doesnt like UUID
    var bodytext: String?
}


