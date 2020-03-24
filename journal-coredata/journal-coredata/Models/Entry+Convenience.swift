//
//  Entry+Convenience.swift
//  journal-coredata
//
//  Created by Karen Rodriguez on 3/23/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case sad = "☹️"
    case neutral = "😐"
    case happy = "🙂"
}

extension Entry {
    @discardableResult convenience init(identifier: String = UUID().uuidString,
                                        title: String,
                                        bodyText: String? = nil,
                                        timestamp: Date = Date(),
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText ?? ""
        self.timestamp = timestamp
    }
}
