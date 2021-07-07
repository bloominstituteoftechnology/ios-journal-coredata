//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Sal Amer on 2/12/20.
//  Copyright © 2020 Sal Amer. All rights reserved.
//

import Foundation
import CoreData

enum MoodStatus: String {
    case 😖
    case 😐
    case 😎
    
    static var allMoods: [MoodStatus] {
        return [😖, 😐, 😎]
    }
}

extension Entry {
    @discardableResult
    convenience init(title: String, bodytext: String, mood: String, timestamp: Date, identifier: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodytext = bodytext
        self.identifier = identifier
        self.timestamp = timestamp
        self.mood = mood
        //NS Date? do i need to initialize - not here 
        //Consider giving default values to the timestamp - How ?
    }
}
