//
//  EntryDetailViewController.swift
//  journal-core-data-project
//
//  Created by Vuk Radosavljevic on 8/13/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    //MARK: - Properties
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    //MARK: - Methods
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text,
            let bodyText = bodyTextView.text else {return}
        let mood = Mood.allMoods[moodSegmentedControl.selectedSegmentIndex].rawValue
        if let entry = entry {
            entryController?.update(entry: entry, title: title, bodyText: bodyText, mood: mood)
        } else {
            entryController?.create(title: title, bodyText: bodyText, mood: mood)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    func updateViews() {
        guard isViewLoaded else {return}
        guard let entry = entry else {return}
        title = entry.title ?? "Create Entry"
        titleTextField.text = entry.title
        bodyTextView.text = entry.bodyText
        guard let moodString = entry.mood,
            let mood = Mood(rawValue: moodString) else {return}
        moodSegmentedControl.selectedSegmentIndex = Mood.allMoods.index(of: mood)!
    }
    
}
