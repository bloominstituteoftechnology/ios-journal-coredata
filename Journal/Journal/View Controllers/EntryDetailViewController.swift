//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Dillon P on 10/4/19.
//  Copyright © 2019 Lambda iOSPT2. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty, let bodyText = entryTextView.text, !bodyText.isEmpty else { return }
        
        
        let moodString = String(moodSegmentedControl.selectedSegmentIndex)
        
        
        if let entry = entry {
            entryController?.updateEntry(title: title, bodyText: bodyText, mood: moodString, entry: entry)
            navigationController?.popViewController(animated: true)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText, mood: moodString)
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        if let entry = entry {
            title = entry.title
            titleTextField.text = entry.title
            entryTextView.text = entry.bodyText
            
            if let moodString = entry.mood, let moodIndex = Int(moodString) {
                moodSegmentedControl.selectedSegmentIndex = moodIndex
            }
            
        } else {
            title = "Create Entry"
            moodSegmentedControl.selectedSegmentIndex = 1
        }
        
    }
    

}
