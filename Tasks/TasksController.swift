//
//  TasksController.swift
//  Tasks
//
//  Created by Julian A. Fordyce on 6/5/19.
//  Copyright © 2019 Glas Labs. All rights reserved.
//

import Foundation
import CoreData


let baseURL = URL(string: "https://tasks-3f211.firebaseio.com/")!

class TasksController {
    
    init() {
        fetchTasksFromServer()
    }
    

typealias CompletionHandler = (Error?) -> Void
    
    func fetchTasksFromServer(completion: @escaping CompletionHandler = { _ in}) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        // wwww.hjsddfhgdfhkshdfklfhd.com/.json
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                completion(error)
                return
            }
        
            guard let data = data else {
                NSLog("No data returned by data task")
                completion(NSError())
                return
            }
            
            //DispatchQueue.main.async {
                do {
                    let taskRepresentationsDict = try JSONDecoder().decode([String: TaskRepresentation].self, from: data)
                    let taskRepresentations = Array(taskRepresentationsDict.values)
                    // add moc
                    // updateTasks
                    
                    // move this to update tasks func
                    for taskRep in taskRepresentations {
                        
                        let uuid = taskRep.identifier
                        
                        if let task = self.task(forUUID: uuid) {
                            // we already have a local task for this
                            self.update(task: task, with: taskRep)
                        } else {
                            // We need to create a new task in core data
                            let _ = Task(taskRepresentation: taskRep)
                        }
                    }
                    // save changes to disk
                    let moc = CoreDataStack.shared.mainContext
                    try moc.save()
                } catch {
                    NSLog("Error decoding tasks: \(error)")
                    completion(error)
                    return
                }
                
                completion(nil)
            //}
        }.resume()
        
    }
    
    private func updateTasks() {
        
        
        
        
        
        
        
    }
    
    
    
    // I already have this task, just checking to see if its been update
    
    func update(task: Task, with representation: TaskRepresentation) {
        task.name = representation.name
        task.notes = representation.notes
        task.priority = representation.priority.rawValue
        
    }
    
    

    
    func deleteTaskFromServer(_ task: Task, completion: @escaping CompletionHandler = { _ in }) {
    
        guard let uuid = task.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
    var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response!)
            completion(error)
        }.resume()
    
    }
    
    // This allows us to put task on server
    
    func put(task: Task, completion: @escaping CompletionHandler = { _ in}) {
        
        let uuid = task.identifier ?? UUID()
        task.identifier = uuid
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard let representation = task.taskRepresentation else { throw NSError() }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding task: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTting task to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    
    }
    
    
    
    
    // This allows us to check if a task with a particular identifier exist
    
    private func task(forUUID uuid: UUID, in context: NSManagedObjectContext) -> Task? {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid as NSUUID) // identifier == uuid
        var result: Task? = nil
        
        context.performAndWait {
            do {
                result = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching task with uuid \(uuid): \(error)")
            }
        }
        return result
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
