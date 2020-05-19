//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Nonye on 5/18/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import Foundation
import CoreData

    enum Mood: String, CaseIterable {
        case happy = "😄"
        case sad = "☹️"
        case neutral = "😐"
    }

    extension Entry {
    @discardableResult convenience init(indentifier: String = String(),
                                        title: String,
                                        bodyText: String,
                                        timeStamp: Date = Date(),
                                        mood: Mood = .neutral,
                                        context: NSManagedObjectContext) {
                                
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.mood = mood.rawValue
        
      
    }
}

