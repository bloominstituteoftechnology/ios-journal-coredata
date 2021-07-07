//
//  EntryRepresentation.swift
//  Journal (Core Data)
//
//  Created by Alex Shillingford on 9/18/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    let title: String
    let bodyText: String
    let timeStamp: Date
    let mood: String
    let identifier: String
}
