//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Daniela Parra on 9/19/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable, Equatable {
    let title: String
    let bodyText: String
    let timestamp: Date
    let identifier: String
    let mood: String
}
