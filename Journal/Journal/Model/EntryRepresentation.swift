//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Kat Milton on 7/24/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable {
    var title: String?
    var bodyText: String?
    var timeStamp: Date?
    var identifier: String?
}


