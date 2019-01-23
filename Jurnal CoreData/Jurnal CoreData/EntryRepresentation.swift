//
//  EntryRepresentation.swift
//  Jurnal CoreData
//
//  Created by Sergey Osipyan on 1/23/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import Foundation


struct EntryRepresentation: Codable, Equatable {
    
    
    let bodyText: String?
    let identifier: String
    let mood: String
    let timestamp: Date?
    let title: String
}
