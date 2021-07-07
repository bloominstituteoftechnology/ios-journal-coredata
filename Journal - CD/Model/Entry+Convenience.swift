//
//  Entry+Convenience.swift
//  Journal - CD
//
//  Created by Angelique Abacajan on 12/16/19.
//  Copyright © 2019 Angelique Abacajan. All rights reserved.
//

import CoreData

extension Entry {
    
    init(title: String, bodyText: String, timestamp: Date = Date()) {
            self.title = title
            self.bodyText = bodyText
            self.timestamp = timestamp
    }
}
