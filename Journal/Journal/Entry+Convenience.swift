//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Thomas Cacciatore on 6/10/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import Foundation
import CoreData

enum Moods: String {
    case 🙁
    case 😐
    case 😀
    
    static var allMoods: [Moods] {
        return [.🙁, .😐, .😀]
    }
}


extension Entry {
    convenience init(title: String, bodyText: String, timeStamp: Date = Date(), identifier: String = NSUUID().uuidString, mood: Moods = .😐 ,context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
}
