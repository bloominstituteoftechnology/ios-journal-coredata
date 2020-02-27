//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Lambda_School_Loaner_268 on 2/26/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation


struct EntryRepresentation: Codable {
    var title: String?
    var bodyText: String?
    var timeStamp: Date?
    var identifier: String?
    var mood: String
    
    
}
