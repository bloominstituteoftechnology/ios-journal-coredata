//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Lydia Zhang on 3/26/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation
struct EntryRepresentation: Codable, Equatable{
    var title: String
    var bodyText: String?
    var timestamp: Date
    var identifier: UUID
    var mood: Mood
    
}
