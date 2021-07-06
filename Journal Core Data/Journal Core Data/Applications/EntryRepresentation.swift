//
//  EntryRepresentation.swift
//  Journal Core Data
//
//  Created by Bhawnish Kumar on 3/26/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    let title: String
    let bodyText: String
    let mood: String
    let timestamp: Date
    let identifier: String
}
