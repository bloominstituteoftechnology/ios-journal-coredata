//
//  Entry+Convenience.swift
//  Journal CoreData
//
//  Created by Ilgar Ilyasov on 9/24/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String {
    case 😔
    case 😐
    case 😁
    
    static var allMoods: [Mood] {
        return [.😔, .😐, .😁]
    }
}

extension Entry {
    
    @discardableResult convenience init(title: String,
                                        bodyText: String? = nil,
                                        mood: Mood = .😐,
                                        timestamp: Date = Date(),
                                        identifier: String = UUID().uuidString,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.rawValue
        self.timestamp = timestamp
        self.identifier = identifier
    }
}
