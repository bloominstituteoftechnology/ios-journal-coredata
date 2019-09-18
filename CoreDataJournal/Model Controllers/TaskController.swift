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
    
    init(){
        fetchTaskFromServer()
    }
    
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
          request.httpBody = try JSONEncoder().encode(taskRepresentation)
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
    
    
    func fetchTaskFromServer(completion: @escaping()-> Void = {}) {
        
        
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error{
                NSLog("error fetching tasks: \(error)")
                completion()
            }
            
            guard let data = data else{
                NSLog("Error getting data task:")
                completion()
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                //Gives us full array of task representation
                let taskRepresentations = Array(try decoder.decode([String: TaskRepresentation].self, from: data).values)
                
                self.update(with: taskRepresentations)
                
                
                
            } catch {
                NSLog("Error decoding: \(error)")
                
            }
            
            }.resume()
        
        
    }
    
    func update(with representations: [TaskRepresentation]){
        
        
        let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier)})
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        //Make a mutable copy of Dictionary above
        var tasksToCreate = representationsByID
        
        
        
        do {
            let context = CoreDataStack.share.mainContext
            
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            //Name of Attibute
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
            
            //Which of these tasks already exist in core data?
            let exisitingTask = try context.fetch(fetchRequest)
            
            //Which need to be updated? Which need to be put into core data?
            for task in exisitingTask {
                guard let identifier = task.identifier,
                    // This gets the task representation that corresponds to the task from Core Data
                    let representation = representationsByID[identifier] else{return}
                
                task.title = representation.title
                task.journalNote = representation.journalNote
                task.mood = representation.mood
                
                tasksToCreate.removeValue(forKey: identifier)
                
            }
            //Take these tasks that arent in core data and create
            for representation in tasksToCreate.values{
                Task(taskRepresentation: representation, context: context)
            }
            
            CoreDataStack.share.saveToPersistentStore()
            
        } catch {
            NSLog("Error fetching tasks from persistent store: \(error)")
        }
        
        
    }
    
    
    
    
    
    
    //CRUD
    
    @discardableResult func createTask(with title: String, journalNote: String?, mood: TaskMood) -> Task {
        let task = Task(title: title, journalNote: journalNote, mood: mood, context: CoreDataStack.share.mainContext)
        
        put(task: task)
        CoreDataStack.share.saveToPersistentStore()
        
        return task
        
    }
    
    func updateTask(task: Task, with title: String, journalNote: String?, mood: TaskMood) {
        task.title = title
        task.journalNote = journalNote
        task.mood = mood.rawValue
        
        put(task: task)
        CoreDataStack.share.saveToPersistentStore()
    }
    
    func delete(task: Task) {
        CoreDataStack.share.mainContext.delete(task)
        CoreDataStack.share.saveToPersistentStore()
    }
    
    
}
