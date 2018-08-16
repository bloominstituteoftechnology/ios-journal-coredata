//
//  EntryRepresentation.swift
//  JournalWithCoreData
//
//  Created by Carolyn Lea on 8/15/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable
{
    var title: String
    var bodyText: String
    var timestamp: Date
    var identifier: String
    var mood: String
}


