//
//  EntryDetailViewController.swift
//  CoreJournal
//
//  Created by Jocelyn Stuart on 2/11/19.
//  Copyright © 2019 JS. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    
    var entryController: EntryController?
    
    var entry: Entry? {
        didSet{
            updateViews()
        }
    }
    
    func updateViews() {
        
        if let entry = entry, isViewLoaded {
            title = entry.title
            
            guard let moodString = entry.mood, let mood = EntryMood(rawValue: moodString), let index = EntryMood.allMoods.firstIndex(of: mood) else { return }
            
            emotionSegmentedControl.selectedSegmentIndex = index
            
            titleTextField.text = entry.title
            bodyTextView.text = entry.bodyText
            
        } else {
            title = "Create New Entry"
        }
        
        
    }
    
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, let bodyText = bodyTextView.text else { return }
        
        let moodIndex = emotionSegmentedControl.selectedSegmentIndex
        let mood = EntryMood.allMoods[moodIndex]
        
        
        if let entry = entry {
            
            entryController?.update(withEntry: entry, andTitle: title, andBody: bodyText, andMood: mood.rawValue)
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            
        } else {
            entryController?.create(withTitle: title, andBody: bodyText, andMood: mood.rawValue)
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
          
        }
        
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBOutlet weak var emotionSegmentedControl: UISegmentedControl!
    
    
    

}
