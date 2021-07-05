//
//  JournalDetailViewController.swift
//  CoreDataJournal
//
//  Created by Austin Potts on 9/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class JournalDetailViewController: UIViewController {

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var moodSegmentController: UISegmentedControl!
    
    var taskController: TaskController?
    var task: Task?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    

    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text,
            let journalNote = journalTextView.text,
            !title.isEmpty else {return}
        
        //check which segment is selected and create a string constant that holds the corresponding mood
        let index = moodSegmentController.selectedSegmentIndex
        let mood = TaskMood.allCases[index]
        
        if let task = task {
            taskController?.updateTask(task: task, with: title, journalNote: journalNote, mood: mood)
        } else {
            taskController?.createTask(with: title, journalNote: journalNote, mood: mood)
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    
    func updateViews(){
        title = task?.title ?? "Create Task"
        
        titleTextField.text = task?.title
        journalTextView.text = task?.journalNote
        
        
        if let moodString = task?.mood,
            let mood = TaskMood(rawValue: moodString) {
            
            let index = TaskMood.allCases.firstIndex(of: mood) ?? 0
            
            moodSegmentController.selectedSegmentIndex = index
        }
        
    }

}
