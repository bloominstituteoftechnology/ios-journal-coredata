//
//  ViewController.swift
//  Journal
//
//  Created by Thomas Dye on 4/22/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMoodSegmentedControl()
        // Do any additional setup after loading the view.
    }

    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        
        if let title = titleTextField.text,
            !title.isEmpty,
            let notes = bodyTextView.text,
            !notes.isEmpty {
            
            let selectedMood = moodSegmentedControl.selectedSegmentIndex
            let mood = Mood.allCases[selectedMood]
            
            let entry = Entry(title: title,
                  bodyText: notes,
                  mood: mood,
                  context: CoreDataStack.shared.mainContext)
            
            entryController?.sendEntryToServer(entry: entry, completion: { _ in })
            
            let context = CoreDataStack.shared.container.newBackgroundContext()
            
            do {
                try CoreDataStack.shared.save(context: context)
                navigationController?.dismiss(animated: true)
            } catch {
                NSLog("Error saving Entry to context: \(error)")
                context.reset()
            }
        }
    }
    
    func setUpMoodSegmentedControl() {
        moodSegmentedControl.setTitle("😢", forSegmentAt: 0)
        moodSegmentedControl.setTitle("😐", forSegmentAt: 1)
        moodSegmentedControl.setTitle("😊", forSegmentAt: 2)
    }
}

