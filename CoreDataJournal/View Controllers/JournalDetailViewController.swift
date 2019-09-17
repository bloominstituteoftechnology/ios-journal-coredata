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
        
        if let task = task {
            taskController?.updateTask(task: task, with: title, journalNote: journalNote)
        } else {
            taskController?.createTask(with: title, journalNote: journalNote)
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    
    func updateViews(){
        title = task?.title ?? "Create Task"
        
        titleTextField.text = task?.title
        journalTextView.text = task?.journalNote
        
    }

}
