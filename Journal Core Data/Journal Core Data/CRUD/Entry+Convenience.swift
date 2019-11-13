//
//  Entry+Convenience.swift
//  Journal Core Data
//
//  Created by Niranjan Kumar on 11/11/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😁 , 🧐 , 😥
}

extension Entry {
    convenience init (title: String,
                      bodyText: String,
                      mood: Mood = .🧐 ,
                      identifier: String,
                      timeStamp: Date,
                      context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.rawValue
        self.identifier = identifier
        self.timeStamp = timeStamp
    }
}
    
    


