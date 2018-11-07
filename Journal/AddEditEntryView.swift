//
//  ViewController.swift
//  Journal
//
//  Created by Lotanna Igwe-Odunze on 11/5/18.
//  Copyright © 2018 Lotanna. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class AddEditEntryView: UIViewController {
        
        var entry: Entry? {
            didSet { updateViews() } //Producing the task triggers data reload
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            updateViews() //Load the data again in case it was stopped by the guard below
        }
        
        private func updateViews() {
            guard isViewLoaded else { return } //Don't reload the data if the view hasn't loaded
            
            title = entry?.title ?? "Add New Task" //Title sets the view title
            titleInput.text = entry?.title
            notesInput.text = entry?.notes
            
        }
        
        //Outlets and Actions
        
        @IBOutlet weak var titleInput: UITextField!
        @IBOutlet weak var notesInput: UITextView!
        @IBAction func saveEntry(_ sender: UIButton) {
            
            guard let title = titleInput.text, !title.isEmpty else { return }
            //Grab the title content
            let notes = notesInput.text //Grab the notes content
            
            if let entry = entry {
                //Editing existing task
                
                entry.title = title
                entry.notes = notes
            } else { let newEntry = Entry(title: title, notes: notes) }
            //No need to append/use newEntry because Core Data
            let moc = CoreDataStack.shared.mainContext
            do { try moc.save() } catch { NSLog("Error saving managed object context: \(error)") }
            
            navigationController?.popViewController(animated: true)
        }//End of save button
        
    }//End of class

