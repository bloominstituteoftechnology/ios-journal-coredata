//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Andrew Liao on 8/13/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let titleInput = titleField.text,
           let bodyTextInput = bodyTextView.text,
        let entryController = entryController,
        let index = segmentedControl?.selectedSegmentIndex else {return}
        if let entry = entry {
            entryController.update(forEntry: entry, withTitle: titleInput, bodyText: bodyTextInput, mood: MoodType.types[index].rawValue )
        } else {
            entryController.create(withTitle: titleInput, bodyText: bodyTextInput, mood:  MoodType.types[index].rawValue)
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    
    func updateViews(){
        if !isViewLoaded {return}
        if let entry = entry{
            self.title = entry.title
            titleField.text = entry.title
            if let bodyText = entry.bodyText {
                bodyTextView.text = bodyText
            }
            //Why is mood optional?
            let mood = MoodType(rawValue: entry.mood!)!
            let moodIndex = MoodType.types.index(of: mood)!
            segmentedControl.selectedSegmentIndex = moodIndex
        } else {
            self.title = "Create Entry"
        }
    }
    
    //MARK: - Properties
    var entry: Entry? {
        didSet{
            updateViews()
        }
    }
    var entryController: EntryController?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
}
