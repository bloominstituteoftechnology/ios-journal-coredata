//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jesse Ruiz on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case sad = "😩"
    case eh = "😕"
    case happy = "😄"
}

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String, timestamp: Date = Date.init(timeIntervalSinceNow: 0), identifier: String = "", mood: String, context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
    

}
