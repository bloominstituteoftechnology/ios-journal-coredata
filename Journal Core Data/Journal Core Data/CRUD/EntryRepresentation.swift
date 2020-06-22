//
//  EntryRepresentation.swift
//  Journal Core Data
//
//  Created by Niranjan Kumar on 11/13/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import Foundation


struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String
    var mood: String
    var timeStamp: Date
    var identifier: String
    
}
