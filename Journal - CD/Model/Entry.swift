//
//  Entry.swift
//  Journal - CD
//
//  Created by Angelique Abacajan on 12/16/19.
//  Copyright © 2019 Angelique Abacajan. All rights reserved.
//

import Foundation

struct Entry: Codable {
    let title: String
    let mood: String
    let bodyText: String?
    let identifier: String
    let timestamp: Date
}
