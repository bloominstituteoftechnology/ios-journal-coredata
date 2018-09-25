//
//  Entry+Convenience.swift
//  Journal CoreData
//
//  Created by Iyin Raphael on 9/24/18.
//  Copyright © 2018 Iyin Raphael. All rights reserved.
//

import Foundation
import CoreData


enum moodType: String {
    case sad = "😟"
    case normal = "😐"
    case happy = "😊"
    
    static var allMoods: [moodType] {
        return [.sad, .normal, .happy]
    }
}

extension Entry{
    
    convenience init(title: String, bodyText: String, date: Date = Date(), mood: moodType = .normal,  context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.date = date 
        
    }
}
