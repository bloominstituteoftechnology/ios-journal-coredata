//
//  Entry+Convenience.swift
//  JournalCoreData
//
//  Created by Angel Buenrostro on 2/11/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.


import CoreData

extension Entry {
    
    enum Mood: String {
        case 🤩
        case 🥴
        case 🤬
    }
    
    static var allMoods: [String] {
        return ["🤩", "🥴","🤬"]
    }
    
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = randomString(length: 10), mood: String,  context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.mood = mood
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0...length-1).map{ _ in letters.randomElement()! })
}
