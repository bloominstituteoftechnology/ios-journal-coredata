//
//  EntryDetailViewController.swift
//  Journal2
//
//  Created by Carolyn Lea on 8/20/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController
{
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    var entry: Entry?
    {
        didSet
        {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        updateViews()
    }

    @IBAction func saveEntry(_ sender: Any)
    {
        guard let title = titleTextField.text,
            let bodyText = bodyTextView.text else {return}
        let selectedMood = Mood.allMoods[moodSegmentedControl.selectedSegmentIndex]
        
        let updateDate = Date()
        
        if let entry = entry
        {
            entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText, timestamp: updateDate as Date, mood: selectedMood.rawValue)
        }
        else
        {
            entryController?.createEntry(title: title, bodyText: bodyText, mood: selectedMood.rawValue)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews()
    {
        guard isViewLoaded else {return}
        
        title = entry?.title ?? "Create Entry"
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.bodyText
        
        guard let moodString = entry?.mood,
            let mood = Mood(rawValue: moodString) else {return}
        moodSegmentedControl.selectedSegmentIndex = Mood.allMoods.index(of: mood)!
        
    }
    
    

}
