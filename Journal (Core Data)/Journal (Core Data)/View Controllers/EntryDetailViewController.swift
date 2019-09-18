//
//  EntryDetailViewController.swift
//  Journal (Core Data)
//
//  Created by Alex Shillingford on 9/16/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import UIKit

@IBDesignable class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.borderColor = UIColor.darkGray.cgColor
        descriptionTextView.layer.cornerRadius = 6.0
        updateViews()
    }
    
    func updateViews() {
        if isViewLoaded {
            self.title = entry?.title ?? "Create Entry"
            self.titleTextField.text = entry?.title
            self.descriptionTextView.text = entry?.bodyText
            
            if let moodString = entry?.mood,
                let mood = Mood(rawValue: moodString) {
                let index = Mood.allCases.firstIndex(of: mood) ?? 1
                moodSegmentedControl.selectedSegmentIndex = index
            }
        }
    }
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let titleText = titleTextField.text,
            !titleText.isEmpty,
            let bodyText = descriptionTextView.text,
            !bodyText.isEmpty else { return }
        
        let index = moodSegmentedControl.selectedSegmentIndex
        let mood = Mood.allCases[index]
        
        if let entry = entry {
            entryController?.updateEntry(entry: entry, title: titleText, bodyText: bodyText, mood: mood)
        } else {
            entryController?.createEntry(title: titleText, bodyText: bodyText, timeStamp: Date(), mood: mood)
        }
        
        navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
