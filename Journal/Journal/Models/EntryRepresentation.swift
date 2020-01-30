//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Tobi Kuyoro on 29/01/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    let title: String
    let timeStamp: Date
    let mood: String
    let identifier: String
    let bodyText: String
}
