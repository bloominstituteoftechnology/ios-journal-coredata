//
//  EntryDetailViewController.swift
//  Journal: Core Data
//
//  Created by Ivan Caldwell on 1/22/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    var entryController: EntryController?
    var entry: Entry?{
        didSet{
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews(){
        guard isViewLoaded == true else { return }
        if let e = entry {
            titleTextField.text = e.title
            bodyTextView.text = e.bodyText
            let mood = e.moodEmoji
            let index = MoodEmoji.allCases.index(of: mood)!
            moodSegmentedControl.selectedSegmentIndex = index
            title = e.title
        } else {
            // createa task
            title = "Create Entry"
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, let bodyText = bodyTextView.text, title.isEmpty == false else {
            return
        }
        if let existingEntry = entry {
            // editing a entry
            let index = moodSegmentedControl.selectedSegmentIndex
            let mood = moodSegmentedControl.titleForSegment(at: index)!
            entryController?.update(entry: existingEntry, title: title, bodyText: bodyText, mood: mood)
        } else {
            // creating a new entry
            //let newEntry = Entry(context: CoreDataStack.shared.mainContext)
            let index = moodSegmentedControl.selectedSegmentIndex
            let mood = moodSegmentedControl.titleForSegment(at: index)!
            entryController?.create(title: title, bodyText: bodyText, mood: mood)//(entry: existingEntry, title: title, bodyText: bodyText, mood: mood)
        }
        navigationController?.popViewController(animated: true)
    }
}
