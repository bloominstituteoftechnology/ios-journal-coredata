//
//  Task+Conveneince.swift
//  CoreDataJournal
//
//  Created by Austin Potts on 9/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData


enum TaskMood: String, CaseIterable {
    case 😞
    case 😕
    case 🙂
}


extension Task {
    
    //Core Data creates the Task Class then we add function to it
    convenience init(title: String, journalNote: String?, mood: TaskMood, context: NSManagedObjectContext) {
        
        
        //Setting up the generic NSManageObject functionality of the model object
        self.init(context: context)
        
        //Once we have the object we can sculpt it self = Task
        self.title = title
        self.journalNote = journalNote
        self.mood = mood.rawValue
        
        
    }
    
    
    
}
