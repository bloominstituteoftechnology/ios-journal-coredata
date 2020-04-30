//
//  EntryDetailViewController.swift
//  ios-journal-coredata
//
//  Created by De MicheliStefano on 13.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText
        guard let moodString = entry?.mood, let mood = MoodTypes(rawValue: moodString) else { return }
        
        moodSelector.selectedSegmentIndex = MoodTypes.all.index(of: mood) ?? 1
    }

    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text,
            !title.isEmpty, let bodyText = bodyTextView.text else { return }
        let mood = MoodTypes.all[moodSelector.selectedSegmentIndex].rawValue
        
        if let entry = entry, let entryController = entryController {
            entryController.update(entry: entry, title: title, bodyText: bodyText, mood: mood)
        } else {
            entryController?.create(title: title, bodyText: bodyText, mood: mood)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    var entryController: EntryController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSelector: UISegmentedControl!
    
}
