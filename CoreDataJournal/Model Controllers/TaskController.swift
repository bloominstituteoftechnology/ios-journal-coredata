//
//  TaskController.swift
//  CoreDataJournal
//
//  Created by Austin Potts on 9/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String{
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}


class TaskController {
    
    
    
    let baseURL = URL(string: "https://journal-9c351.firebaseio.com/")!
    
    
    func put(task: Task, completion: @escaping()-> Void = {}) {
        
        let identifier = task.identifier ?? UUID()
        task.identifier = identifier
        
        let requestURL = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let taskRepresentation = task.taskRepresentation else{
            NSLog("Error")
            completion()
            return
        }
        
        do{
          request.httpBody = try JSONEncoder.encode(taskRepresentation)
        } catch {
            NSLog("Error encoding task: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error{
                NSLog("Error putting task: \(error)")
                completion()
                return
            }
            completion()
            }.resume()
        
        
    }
    
    
    
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
