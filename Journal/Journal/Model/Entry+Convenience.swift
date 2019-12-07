//
//  Entry+Convenience.swift
//  Journal
//
//  Created by denis cedeno on 12/4/19.
//  Copyright © 2019 DenCedeno Co. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case happy = "😃"
    case neutral = "😐"
    case sad = "☹️"
    
    static var allMoods: [Mood] {
        return [.happy , .neutral , .sad]
    }
}

extension Entry {
    convenience init(title: String,
                     bodyText: String,
                     mood: String,
                     timeStamp: Date = Date(),
                     identifier: String = "UUID().uuidString",
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood
        self.timeStamp = timeStamp
        self.identifier = identifier
    }
}

