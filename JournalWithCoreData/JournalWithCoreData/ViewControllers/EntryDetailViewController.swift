//
//  EntryDetailViewController.swift
//  JournalWithCoreData
//
//  Created by Carolyn Lea on 8/13/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController
{
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextTextView: UITextView!
    @IBOutlet weak var moodSegmentControl: UISegmentedControl!
    
    var entry: Entry?
    {
        didSet
        {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateViews()
    }

    @IBAction func save(_ sender: Any)
    {
        guard let title = titleTextField.text,
            let bodyText = bodyTextTextView.text else {return}
        let newTime = Date()
        let mood = EntryMood.allMoods[moodSegmentControl.selectedSegmentIndex]
        
        if let entry = entry 
        {
            entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText, timestamp: newTime as NSDate, mood: mood)
            print(titleTextField.text!, bodyTextTextView.text, mood)
        }
        else
        {
            entryController?.createEntry(title: title, bodyText: bodyText, mood: mood)
            print(titleTextField.text!, bodyTextTextView.text, mood)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews()
    {
        guard isViewLoaded else {return}
        
        guard let entry = entry else {
            title = "Create Entry"
            return
        }
        title = entry.title
        titleTextField.text = entry.title
        bodyTextTextView.text = entry.bodyText
        
        guard let moodString = entry.mood,
            let mood = EntryMood(rawValue: moodString) else {return}
        moodSegmentControl.selectedSegmentIndex = EntryMood.allMoods.index(of: mood)!
    }
    

}
