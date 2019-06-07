//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Sameera Roussi on 6/6/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable {
    let title: String
    let bodyText: String?
    let mood: String
    let timestamp: Date?
    let identifier: UUID
}
