//
//  TaskController.swift
//  CoreDataJournal
//
//  Created by Austin Potts on 9/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation


class TaskController {
    
    //CRUD
    
    @discardableResult func createTask(with title: String, journalNote: String?, mood: TaskMood) -> Task {
        let task = Task(title: title, journalNote: journalNote, mood: mood, context: CoreDataStack.share.mainContext)
        
        CoreDataStack.share.saveToPersistentStore()
        
        return task
        
    }
    
    func updateTask(task: Task, with title: String, journalNote: String?, mood: TaskMood) {
        task.title = title
        task.journalNote = journalNote
        task.mood = mood.rawValue
        
        CoreDataStack.share.saveToPersistentStore()
    }
    
    func delete(task: Task) {
        CoreDataStack.share.mainContext.delete(task)
        CoreDataStack.share.saveToPersistentStore()
    }
    
    
}
