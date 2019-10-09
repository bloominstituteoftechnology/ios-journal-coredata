//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Jessie Ann Griffin on 10/8/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    
    let title: String
    let bodyText: String?
    let timeStamp: Date
    let mood: String
    let identifier: String?

}
