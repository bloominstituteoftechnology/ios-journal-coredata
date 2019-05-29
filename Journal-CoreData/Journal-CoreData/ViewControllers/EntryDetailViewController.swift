//
//  EntryDetailViewController.swift
//  Journal-CoreData
//
//  Created by Sameera Roussi on 5/27/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodSegmentControl: UISegmentedControl!
    
    // MARK: - Properties
    var entryController: EntryController?
    var entry: Entry?
    
    
    
    // MARK: - View States
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Are we doing a new entry or an update?
        updateViews()
    }
    
    
    // MARK: - View Functions
    
    func updateViews() {
        if isViewLoaded  {
    
            // An entry was sent
            if entry != nil {
                title = entry?.title
                titleTextField.text = entry?.title
                entryTextView.text = entry?.bodyText
                
            // No entry was sent
            } else {
                title = "New Entry"
                return
            }
        }
    }

    
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text else { return }
        guard let bodyText = entryTextView.text else { return }
        
        if self.entry != nil {
            // We are updating an entry
            guard let entry = entry else { return }
            entryController?.update(entry: entry, title: title, bodyText: bodyText)
        } else {
            // We are adding a new entry
            entryController?.createEntry(title: title, bodyText: bodyText)
        }
        
        // Go back to the view
        _ = navigationController?.popViewController(animated: true)
        
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
