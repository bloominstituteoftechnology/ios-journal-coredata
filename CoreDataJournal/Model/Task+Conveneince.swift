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
    
    var taskRepresentation: TaskRepresentation? {
        guard let title = title,
            let mood = mood,
            let identifier = identifier?.uuidString else{return nil}
        return TaskRepresentation(title: title, journalNote: journalNote, mood: mood, identifier: identifier)
    }
    
    
    //Core Data creates the Task Class then we add function to it
    convenience init(title: String, journalNote: String?, mood: TaskMood, identifier: UUID = UUID(), context: NSManagedObjectContext) {
        
        
        //Setting up the generic NSManageObject functionality of the model object
        self.init(context: context)
        
        //Once we have the object we can sculpt it self = Task
        self.title = title
        self.journalNote = journalNote
        self.mood = mood.rawValue
        self.identifier = identifier
        
        
    }
    
    
    
}
