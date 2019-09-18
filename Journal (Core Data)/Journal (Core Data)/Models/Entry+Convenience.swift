//
//  Entry+Convenience.swift
//  Journal (Core Data)
//
//  Created by Alex Shillingford on 9/16/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😎
    case 😐
    case 😢
}

extension Entry {
    convenience init(title: String, bodyText: String, timeStamp: Date = Date(), identifier: String, mood: Mood, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
}
