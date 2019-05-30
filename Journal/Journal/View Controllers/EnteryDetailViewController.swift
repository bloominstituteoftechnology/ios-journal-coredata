//
//  EnteryDetailViewController.swift
//  Journal
//
//  Created by Christopher Aronson on 5/27/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit

class EnteryDetailViewController: UIViewController {

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    var entryController: EntryController?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }

    func updateViews() {

        guard isViewLoaded else { return }

        title = entry?.title ?? "Create an Entry"
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText

        moodSegmentedControl.selectedSegmentIndex = entry?.mood == Mood.😊.rawValue ? 2 : entry?.mood == Mood.😐.rawValue ? 1 : 0
    }

    @IBAction func saveButtonTapped(_ sender: Any) {

        guard let title = titleTextField.text,
        let bodyText = bodyTextView.text,
        !title.isEmpty,
        !bodyText.isEmpty
        else {
            return
        }

        let mood = moodSegmentedControl.selectedSegmentIndex == 2 ? Mood.😊.rawValue : moodSegmentedControl.selectedSegmentIndex == 1 ? Mood.😐.rawValue : Mood.😭.rawValue

        CoreDataStack.shared.mainContext.performAndWait {
            if let entry = entry {
                entryController?.update(entry: entry, title: title, bodyText: bodyText, mood: mood)
            } else {
                entryController?.createEntry(title: title, bodyText: bodyText, mood: mood)
            }
        }

        navigationController?.popToRootViewController(animated: true)
    }
}
