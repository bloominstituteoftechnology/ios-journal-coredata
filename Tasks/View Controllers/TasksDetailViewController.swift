//
//  TasksDetailViewController.swift
//  Tasks
//
//  Created by Julian A. Fordyce on 6/3/19.
//  Copyright © 2019 Glas Labs. All rights reserved.
//

import UIKit

class TasksDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

    }
    
    @IBAction func saveTask(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        let priorityIndex = priorityControl.selectedSegmentIndex
        let priority = TaskPriority.allPriorities[priorityIndex]
        let notes = notesTextView.text
        
        if let task = task {
            task.name = name
            task.priority = priority.rawValue
            task.notes = notes
            tasksController.put(task: task)
        } else {
            let task = Task(name: name, notes: notes, priority: priority)
            tasksController.put(task: task)
        }
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    private func updateViews() {
        guard isViewLoaded else {
            return
        }
        
        title = task?.name ?? "Create Task"
        nameTextField.text = task?.name
        notesTextView.text = task?.notes
        
        let priority: TaskPriority
        if let taskPriority = task?.priority {
            priority = TaskPriority(rawValue: taskPriority)!
        } else {
            priority = .normal
        }
        
        priorityControl.selectedSegmentIndex = TaskPriority.allPriorities.firstIndex(of: priority)!
        
    }
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
   
    
  //   MARK: - Properties
    
    
    var tasksController: TasksController!
    var task: Task? {
        didSet {
            updateViews()
        }
    }
    
    
    @IBOutlet weak var priorityControl: UISegmentedControl!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    

}
