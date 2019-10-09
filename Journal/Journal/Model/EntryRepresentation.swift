//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Fabiola S on 10/8/19.
//  Copyright © 2019 Fabiola Saga. All rights reserved.
//

import Foundation
import CoreData

struct EntryRepresentation: Codable {
    var bodyText: String?
    var title: String
    var mood: String
    var timeStamp: Date
    var identifier: String?
}
