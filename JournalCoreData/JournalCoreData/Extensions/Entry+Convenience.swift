//
//  Entry+Convenience.swift
//  JournalCoreData
//
//  Created by Nelson Gonzalez on 2/11/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String { //all cases array thanks to caseIterable
    case 😊
    case 😐
    case 😞
    
    static var allMoods: [Mood] {
        return [.😊, .😐, .😞]
    }
}

extension Entry {
    convenience init(title: String, bodyText: String, date: Date = Date(), identifier: String = UUID().uuidString, mood: Mood = .😐, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = date
        self.identifier = identifier
    }
}
